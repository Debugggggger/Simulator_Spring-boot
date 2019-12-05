package com.drimsys.simulator.util;

import com.drimsys.simulator.dto.Component;
import com.drimsys.simulator.dto.Eq;
import com.drimsys.simulator.dto.xml.Components;
import com.drimsys.simulator.dto.xml.EqXml;
import org.apache.commons.io.FileUtils;
import org.apache.commons.io.filefilter.TrueFileFilter;

import javax.servlet.http.HttpServletRequest;
import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Marshaller;
import java.util.LinkedList;
import java.util.List;

/**
 * 파일 처리를 위한 컨트롤러
 *
 * @author Gyeongseok Seo
 * @version 1.0
 * @since 2019-11-01 14:07
 */

public class File {
    public static final String XML_PATH = "/WEB-INF/resources";

    private static Components initComponents() {
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

    public static boolean save(String name, Eq eq, String path) {
        java.io.File file = new java.io.File(path);

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

        file = new java.io.File(fileName);

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

    public static Eq load(String name, String path) {
        String fileName = name + ".xml";

        JAXBContext jaxbContext;

        java.io.File file = new java.io.File(path + fileName);
        try {
            jaxbContext = JAXBContext.newInstance(EqXml.class);

            return new Eq((EqXml) jaxbContext.createUnmarshaller().unmarshal(file));
        } catch (JAXBException e) {
            e.printStackTrace();
            return null;
        }
    }

    public static List<String> getFiles(String path) {
        List<String> files = new LinkedList<>();

        for(java.io.File info : FileUtils.listFiles(new java.io.File(path), TrueFileFilter.INSTANCE, TrueFileFilter.INSTANCE)) {
            files.add(info.getName().replace(".xml", ""));
        }

        return files;
    }

    public static boolean remove(String name, String path) {
        String fileName = name + ".xml";

        java.io.File file = new java.io.File(path + fileName);

        if(file.exists()) {
            return file.delete();
        }

        return false;
    }

    public static String getXMLPath(HttpServletRequest request) {
        return request.getSession().getServletContext().getRealPath(XML_PATH) + "/";
    }
}
