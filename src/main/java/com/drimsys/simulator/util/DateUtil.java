package com.drimsys.simulator.util;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

public class DateUtil {
    private static String DATE_FORMAT = "yyyy-MM-dd HH:mm:ss.SSS";

    public static String getCurrentDate(){
        Calendar calendar = Calendar.getInstance();
        SimpleDateFormat dateFormat = new SimpleDateFormat(DATE_FORMAT);

        return dateFormat.format(calendar.getTime());
    }

    public static long dateToLong(String form){
        try{
            SimpleDateFormat transFormat = new SimpleDateFormat(DATE_FORMAT);
            Date to = transFormat.parse(form);

            return to.getTime();
        } catch(Exception e) {

            return 0;
        }
    }
}
