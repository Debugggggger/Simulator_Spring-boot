package com.drimsys.simulator.restAPI;

import com.drimsys.simulator.dto.JSONResult;
import com.drimsys.simulator.model.XmlModel;
import com.drimsys.simulator.service.UpDownloaderService;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.util.LinkedList;
import java.util.List;

@RestController
@RequestMapping(value = "/api/file")
public class UpDownloaderAPI{
    private final XmlModel xmlModel = new XmlModel();
    private final UpDownloaderService upDownloaderService = new UpDownloaderService();

    @RequestMapping(value = "/manualFileList", method = RequestMethod.GET)
    public List<String> manualFileListGET() {
        return upDownloaderService.getManualFileNames();
    }

    @RequestMapping(value = "/manualUploader", method = RequestMethod.POST)
    public JSONResult manualUploaderPOST(HttpServletRequest request, @RequestParam("files") MultipartFile[] files) {
        List<String> successFileNames = new LinkedList<>();

        int success = 0;
        int failure = 0;
        String failureFileName = "";

        for(MultipartFile file : files) {
            if ((upDownloaderService.uploader(file, upDownloaderService.getMANUAL_PATH()))) {
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
            File file = new File(upDownloaderService.getMANUAL_PATH() + fileName);
            upDownloaderService.downloader(fileName, file, request, response);
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
            if ((upDownloaderService.uploader(file, xmlModel.getXML_PATH()))) {
                String filename = file.getOriginalFilename();
                if(xmlModel.validation(filename)) {
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
            File file = new File(xmlModel.getXML_PATH() + fileName);
            upDownloaderService.downloader(fileName, file, request, response);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
