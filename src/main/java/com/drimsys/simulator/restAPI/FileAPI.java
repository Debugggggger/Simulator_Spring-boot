package com.drimsys.simulator.restAPI;

import com.drimsys.simulator.dto.Eq;
import com.drimsys.simulator.dto.JSONResult;
import com.drimsys.simulator.util.Convert;
import com.drimsys.simulator.util.File;
import org.apache.commons.io.FileUtils;
import org.apache.commons.io.filefilter.TrueFileFilter;
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
    private boolean validation(String fileName) {
        fileName = fileName.replaceAll(".xml", "");
        Eq eq = File.load(fileName, XML_PATH);
        File.remove(fileName, XML_PATH);

        if(eq == null){
            return false;
        }
        if(eq.getEqSetting() == null) {
            return false;
        }
        if(eq.getEqSetting().getName() == null) {
            return false;
        }

        // 장비명 중복 체크
        for(String eqName : File.getFiles(XML_PATH)) {
            if(eqName.equals(eq.getEqSetting().getName())) {
                return false;
            }
        }

        // 장비 파일 저장
        return File.save(eq.getEqSetting().getName(), eq, XML_PATH);
    }
    private void downloader(String fileName, java.io.File file,
                            HttpServletRequest request, HttpServletResponse response) throws UnsupportedEncodingException {
        request.setCharacterEncoding("UTF-8");

        //파일 업로드된 경로
        try{
            InputStream in = null;
            OutputStream os = null;

            boolean skip = false;
            String client = "";

            //파일을 읽어 스트림에 담기
            try{
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
                PrintWriter out = response.getWriter();
                out.print("<script language='javascript'>alert('파일을 찾을 수 없습니다');history.back();</script>");
            }
            in.close();
            os.close();
        } catch (Exception e) {
            System.out.println("ERROR : " + e.getMessage());
        }
    }

    private boolean uploader(MultipartFile files, String path) {
        try {
            String name = files.getOriginalFilename();
            byte[] data = files.getBytes();

            BufferedOutputStream bs = null;
            try {
                bs = new BufferedOutputStream(new FileOutputStream(path + name));
                bs.write(data);
                bs.close(); //반드시 닫는다.
            } catch (Exception e) {
                e.getStackTrace();
                return false;
            }

            return true;
        }catch (Exception e){
            return false;
        }
    }

    @RequestMapping(value = "/manualFileList", method = RequestMethod.GET)
    public List<String> manualFileListGET() {
        List<String> files = new LinkedList<>();

        for(java.io.File info : FileUtils.listFiles(new java.io.File(MANUAL_PATH), TrueFileFilter.INSTANCE, TrueFileFilter.INSTANCE)) {
            files.add(info.getName());
        }

        return files;
    }

    @RequestMapping(value = "/manualUploader", method = RequestMethod.POST)
    public JSONResult manualUploaderPOST(HttpServletRequest request, @RequestParam("files") MultipartFile[] files) {
        List<String> successFileNames = new LinkedList<>();

        int success = 0;
        int failure = 0;
        String failureFileName = "";

        for(MultipartFile file : files) {
            if ((uploader(file, MANUAL_PATH))) {
                success++;
                successFileNames.add(file.getOriginalFilename());
            } else {
                failure++;
                failureFileName += " " + file.getOriginalFilename() + ",";
            }
        }

        String message = "";
        if(failure > 0) {
            failureFileName = failureFileName.substring(0, failureFileName.length()-1);
            message = "성공 : " + success + " / 실패 : " + failure + " [" + failureFileName + "]";
        } else {
            message = "성공 : " + success;
        }

        return new JSONResult(200, message, successFileNames);
    }

    @RequestMapping(value = "/manualDownloader", method = RequestMethod.GET)
    public void manualDownloadGET(String fileName, HttpServletRequest request, HttpServletResponse response) {
        try{
            java.io.File file = new java.io.File(MANUAL_PATH + fileName);
            downloader(fileName, file, request, response);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @RequestMapping(value = "/eqSettingUploader", method = RequestMethod.POST)
    public JSONResult eqSettingUploaderPOST(HttpServletRequest request, @RequestParam("files") MultipartFile[] files) {
        List<String> successFilename = new LinkedList<>();
        String failureFileName = "";

        int success = 0;
        int failure = 0;

        for(MultipartFile file : files) {
            if ((uploader(file, XML_PATH))) {
                String filename = file.getOriginalFilename();
                if(validation(filename)) {
                    success++;
                    successFilename.add(filename);
                } else {
                    failureFileName += " " + file.getOriginalFilename() + ",";
                    failure++;
                }
            } else {
                failure++;
                failureFileName += " " + file.getOriginalFilename() + ",";
            }
        }

        String message = "";
        if(failure > 0) {
            failureFileName = failureFileName.substring(0, failureFileName.length()-1);
            message = "성공 : " + success + " / 실패 : " + failure + " [" + failureFileName + " ]";
        } else {
            message = "성공 : " + success;
        }

        return new JSONResult(200, message, successFilename);
    }

    @RequestMapping(value = "/eqSettingDownloader", method = RequestMethod.GET)
    public void eqSettingDownloaderGET(String fileName, HttpServletRequest request, HttpServletResponse response) {
        try{
            fileName = fileName + ".xml";
            java.io.File file = new java.io.File(XML_PATH + fileName);
            downloader(fileName, file, request, response);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
