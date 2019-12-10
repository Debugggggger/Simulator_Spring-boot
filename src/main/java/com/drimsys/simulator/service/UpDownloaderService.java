package com.drimsys.simulator.service;

import lombok.Getter;
import org.apache.commons.io.FileUtils;
import org.apache.commons.io.filefilter.TrueFileFilter;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.util.LinkedList;
import java.util.List;

public class UpDownloaderService{
    @Getter
    private final String MANUAL_PATH = "resource/manual/";

    public List<String> getManualFileNames() {
        List<String> files = new LinkedList<>();

        for(File info : FileUtils.listFiles(new File(MANUAL_PATH), TrueFileFilter.INSTANCE, TrueFileFilter.INSTANCE)) {
            files.add(info.getName());
        }

        return files;
    }

    public void downloader(String fileName, File file,
                           HttpServletRequest request, HttpServletResponse response) throws UnsupportedEncodingException{
        request.setCharacterEncoding("UTF-8");

        //파일 업로드된 경로
        try{
            InputStream in = null;
            OutputStream os = null;

            boolean skip = false;

            //파일을 읽어 스트림에 담기
            try{
                in = new FileInputStream(file);
            } catch (FileNotFoundException fe) {
                skip = true;
            }

            String client = request.getHeader("User-Agent");

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

    public boolean uploader(MultipartFile files, String path) {
        try {
            String name = files.getOriginalFilename();
            byte[] data = files.getBytes();

            try {
                BufferedOutputStream bs = new BufferedOutputStream(new FileOutputStream(path + name));
                bs.write(data);
                bs.close();
            } catch (Exception e) {
                e.getStackTrace();
                return false;
            }

            return true;
        } catch (Exception e){
            return false;
        }
    }
}
