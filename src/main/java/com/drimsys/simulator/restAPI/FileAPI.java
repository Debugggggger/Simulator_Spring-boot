package com.drimsys.simulator.restAPI;

import com.drimsys.simulator.dto.Eq;
import com.drimsys.simulator.dto.JSONResult;
import com.drimsys.simulator.util.Convert;
import com.drimsys.simulator.util.File;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.io.BufferedOutputStream;
import java.io.FileInputStream;
import java.io.FileOutputStream;

@RestController
@RequestMapping(value = "/api/file")
public class FileAPI{
    private JSONResult unmarshal(String name, String path, String contents) {
        // 파일 저장
        BufferedOutputStream bs = null;
        try {
            bs = new BufferedOutputStream(new FileOutputStream(path + name + ".xml"));
            bs.write(contents.getBytes());
            bs.close(); //반드시 닫는다.
        } catch (Exception e) {
            e.getStackTrace();
            return new JSONResult(500, "파일형식이 맞지 않습니다.", null);
        }

        // 파일 로드
        Eq eq = File.load(name, path);
        File.remove(name, path);

        if(eq.getEqSetting() == null) {
            return new JSONResult(500, "파일형식이 맞지 않습니다.", null);
        }
        if(eq.getEqSetting().getName() == null) {
            return new JSONResult(500, "파일형식이 맞지 않습니다.", null);
        }

        // 장비명 중복 체크
        for(String eqName : File.getFiles(path)) {
            if(eqName.equals(eq.getEqSetting().getName())) {
                return new JSONResult(500, "해당 장비가 존재합니다.", null);
            }
        }

        // 장비 파일 저장
        if(File.save(eq.getEqSetting().getName(), eq, path)) {
            return new JSONResult(200, eq.getEqSetting().getName() + " 저장 성공", null);
        }

        return new JSONResult(500, "파일저장에 실패했습니다.", null);
    }

    @RequestMapping(value = "/import", method = RequestMethod.POST)
    public JSONResult importPOST(@RequestBody String request,
                                 HttpServletRequest servletRequest) {
        request = Convert.decodeURL(request);

        String path = File.getXMLPath(servletRequest);
        String name = "upload_" + System.currentTimeMillis();

        return unmarshal(name, path, request);
    }

    @RequestMapping(value = "/export", method = RequestMethod.POST)
    public JSONResult exportPOST(@RequestBody String request,
                                 HttpServletRequest servletRequest) {
        request = Convert.decodeURL(request);

        String path = File.getXMLPath(servletRequest);
        String name = request;

        // 장비명 중복 체크
        boolean hasFile = false;
        for(String eqName : File.getFiles(path)) {
            if(eqName.equals(name)) {
                hasFile = true;
                break;
            }
        }

        if(!hasFile) return new JSONResult(404, "해당 장비가 존재하지 않습니다.", null);

        try {
            // 바이트 단위로 파일읽기
            String filePath = path + name + ".xml"; // 대상 파일
            FileInputStream fileStream = null; // 파일 스트림

            fileStream = new FileInputStream( filePath );// 파일 스트림 생성
            //버퍼 선언
            byte[] readBuffer = new byte[fileStream.available()];
            while (fileStream.read(readBuffer) != -1){}

            fileStream.close(); //스트림 닫기
            return new JSONResult(200, "success", new String(readBuffer));
        } catch (Exception e) {
            e.getStackTrace();
            return new JSONResult(500, "Export Error", e.getMessage());
        }
    }
}
