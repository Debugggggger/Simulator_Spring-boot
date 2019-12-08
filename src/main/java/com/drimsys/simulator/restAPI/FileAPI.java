package com.drimsys.simulator.restAPI;

import com.drimsys.simulator.dto.Eq;
import com.drimsys.simulator.dto.JSONResult;
import com.drimsys.simulator.util.Convert;
import com.drimsys.simulator.util.File;
import org.apache.commons.io.FileUtils;
import org.apache.commons.io.filefilter.TrueFileFilter;
import org.springframework.core.io.InputStreamResource;
import org.springframework.core.io.Resource;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.util.LinkedList;
import java.util.List;

import static com.drimsys.simulator.util.File.MANUAL_PATH;
import static com.drimsys.simulator.util.File.XML_PATH;

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

        if(eq == null){
            return new JSONResult(500, "파일형식이 맞지 않습니다.", null);
        }
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

    private boolean uploadFile(MultipartFile files) {
        try {
            String name = files.getOriginalFilename();
            String path = MANUAL_PATH;
            byte[] data = files.getBytes();

            BufferedOutputStream bs = null;
            try {
                bs = new BufferedOutputStream(new FileOutputStream(path + name));
                bs.write(data);
                bs.close(); //반드시 닫는다.
            } catch (Exception e) {
                e.getStackTrace();
            }

            return true;
        }catch (Exception e){
            return false;
        }
    }

    @RequestMapping(value = "/import", method = RequestMethod.POST)
    public JSONResult importPOST(@RequestBody String request) {
        if(request == null)  return new JSONResult(500, "파일형식이 맞지 않습니다.", null);
        if(request.equals(""))  return new JSONResult(500, "파일형식이 맞지 않습니다.", null);

        request = Convert.decodeURL(request);

        String path = XML_PATH;
        String name = "upload_" + System.currentTimeMillis();

        return unmarshal(name, path, request);
    }

    @RequestMapping(value = "/export", method = RequestMethod.POST)
    public JSONResult exportPOST(@RequestBody String request) {
        request = Convert.decodeURL(request);

        String path = XML_PATH;
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

    @RequestMapping(value = "/uploadFiles", method = RequestMethod.POST)
    public JSONResult uploadFile(HttpServletRequest request, @RequestParam("files") MultipartFile[] files) {
        List<Boolean> result = new LinkedList<>();
        String failureFileName = "";

        int success = 0;
        int failure = 0;

        for(MultipartFile file : files) {
            if ((uploadFile(file))) {
                success++;
            } else {
                failure++;
                failureFileName += file.getOriginalFilename() + " ";
            }
        }

        String message = "";
        if(failure > 0) {
            message = "성공 : " + success + " / 실패 : " + failure + "[ " + failureFileName + "]";
        } else {
            message = "성공 : " + success;
        }

        return new JSONResult(200, message, null);
    }

    @RequestMapping(value = "/manualFileList", method = RequestMethod.GET)
    public List<String> manualFileListGET() {
        List<String> files = new LinkedList<>();

        for(java.io.File info : FileUtils.listFiles(new java.io.File(MANUAL_PATH), TrueFileFilter.INSTANCE, TrueFileFilter.INSTANCE)) {
            files.add(info.getName());
        }

        return files;
    }

    @RequestMapping(value = "/manualDownload", method = RequestMethod.GET)
    public void download(String fileName, HttpServletRequest request, HttpServletResponse response) throws UnsupportedEncodingException {
        request.setCharacterEncoding("UTF-8");

        //파일 업로드된 경로
        try{
            java.io.File file = null;
            InputStream in = null;
            OutputStream os = null;

            boolean skip = false;
            String client = "";

            //파일을 읽어 스트림에 담기
            try{
                file = new java.io.File(MANUAL_PATH + fileName);
                in = new FileInputStream(file);
            } catch (FileNotFoundException fe) {
                skip = true;
            }

            client = request.getHeader("User-Agent");

            //파일 다운로드 헤더 지정
            response.reset();
            response.setContentType("application/octet-stream");
            response.setHeader("Content-Description", "JSP Generated Data");

            if (!skip) {
                // IE
                if (client.indexOf("MSIE") != -1) {
                    response.setHeader("Content-Disposition", "attachment; filename=\""
                            + java.net.URLEncoder.encode(fileName, "UTF-8").replaceAll("\\+", "\\ ") + "\"");
                    // IE 11 이상.
                } else if (client.indexOf("Trident") != -1) {
                    response.setHeader("Content-Disposition", "attachment; filename=\""
                            + java.net.URLEncoder.encode(fileName, "UTF-8").replaceAll("\\+", "\\ ") + "\"");
                } else {
                    // 한글 파일명 처리
                    response.setHeader("Content-Disposition",
                            "attachment; filename=\"" + new String(fileName.getBytes("UTF-8"), "ISO8859_1") + "\"");
                    response.setHeader("Content-Type", "application/octet-stream; charset=utf-8");
                }
                response.setHeader("Content-Length", "" + file.length());
                os = response.getOutputStream();
                byte b[] = new byte[(int) file.length()];
                int leng = 0;
                while ((leng = in.read(b)) > 0) {
                    os.write(b, 0, leng);
                }
            } else {
                response.setContentType("text/html;charset=UTF-8");
                System.out.println("<script language='javascript'>alert('파일을 찾을 수 없습니다');history.back();</script>");
            }
            in.close();
            os.close();
        } catch (Exception e) {
            System.out.println("ERROR : " + e.getMessage());
        }
    }
}
