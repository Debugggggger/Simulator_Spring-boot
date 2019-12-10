package com.drimsys.simulator.model;

import com.drimsys.simulator.dto.Component;
import com.drimsys.simulator.dto.Eq;
import com.drimsys.simulator.dto.xml.Components;
import com.drimsys.simulator.dto.xml.EqXml;
import com.drimsys.simulator.util.Convert;
import lombok.Getter;
import org.apache.commons.io.FileUtils;
import org.apache.commons.io.filefilter.TrueFileFilter;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Marshaller;
import java.io.File;
import java.util.LinkedList;
import java.util.List;

public class XmlModel{
    @Getter
    private final String XML_PATH = "resource/xml/";

    private Components initComponents() {
        List<Component> init = new LinkedList<>();
        String[] descriptions = new String[] {
                "Null char", "Start of Heading", "Start of Text", "End of Text", "End of Transmission",
                "Enquiry", "Acknowledgment", "Bell", "Backspace", "Horizontal Tab",
                "New line", "Vertical Tab", "New Page", "Carriage Return", "Shift Out",
                "Shift In", "Data Link Escape", "Device Control 1", "Device Control 2","Device Control 3",
                "Device Control 4", "Negative Acknowledge", "Synchronous Idle", "End of Transmission Block", "Cancel",
                "End of Medium", "Substitute / End of File", "Escape", "File Separator", "Group Separator",
                "Request to Send", "Unit Separator", "Space"
        };

        for(byte b = 0x00; b<=0x20; b++) {
            List<String> values = new LinkedList<>();
            values.add("0x" + String.format("%02X", b));

            Component component = new Component(Convert.checkASCII(b), "Hex", values,1,descriptions[(int)b], "No", false);
            init.add(component);
        }

        return new Components(init);
    }

    public boolean marshalling(String name, Eq eq) {
        String path = XML_PATH;
        File file = new File(path);

        if(!file.exists()) {
            try {
                file.mkdir();
            } catch (Exception e) {
                e.printStackTrace();
                return false;
            }
        }

        // Eq to EqXml;
        EqXml eqXml = new EqXml(eq);

        String fileName = path + name + ".xml";

        JAXBContext jaxbContext;
        Marshaller marshaller;

        file = new File(fileName);

        if(!file.exists()) {
            if(eq.getEqSetting().getTargetEq().equals("")) {
                eqXml.setComponents(initComponents());
            }
        }

        eqXml.getEqSetting().setTargetEq("");
        try {
            jaxbContext = JAXBContext.newInstance(EqXml.class);
            marshaller = jaxbContext.createMarshaller();
            marshaller.setProperty(Marshaller.JAXB_ENCODING, "UTF-8");
            marshaller.setProperty(Marshaller.JAXB_FORMATTED_OUTPUT, true);
            marshaller.marshal(eqXml, file);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public Eq unmarshalling(String name) {
        String path = XML_PATH;
        File file = new File(path);

        if(!file.exists()) {
            try {
                file.mkdir();
            } catch (Exception e) {
                return null;
            }
        }

        String fileName = name + ".xml";

        JAXBContext jaxbContext;

        file = new File(path + fileName);
        try {
            jaxbContext = JAXBContext.newInstance(EqXml.class);

            return new Eq((EqXml) jaxbContext.createUnmarshaller().unmarshal(file));
        } catch (JAXBException e) {
            e.printStackTrace();
            return null;
        }
    }

    public List<String> getFileNames() {
        List<String> files = new LinkedList<>();

        for(File info : FileUtils.listFiles(new File(XML_PATH), TrueFileFilter.INSTANCE, TrueFileFilter.INSTANCE)) {
            files.add(info.getName().replace(".xml", ""));
        }

        return files;
    }

    public boolean remove(String name) {
        String fileName = name + ".xml";

        File file = new File(XML_PATH + fileName);

        if(file.exists()) {
            return file.delete();
        }

        return false;
    }

    public boolean validation(String fileName) {
        fileName = fileName.replaceAll(".xml", "");
        Eq eq = unmarshalling(fileName);
        remove(fileName);

        // 탈출조건
        if(eq == null) return false;
        if(eq.getEqSetting() == null) return false;
        if(eq.getEqSetting().getName() == null) return false;

        // 장비명 중복 체크
        for(String eqName : getFileNames()) {
            if(eqName.equals(eq.getEqSetting().getName())) {
                return false;
            }
        }

        // 장비 파일 저장
        return marshalling(eq.getEqSetting().getName(), eq);
    }
}
