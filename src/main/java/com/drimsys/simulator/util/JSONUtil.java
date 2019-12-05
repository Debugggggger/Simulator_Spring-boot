package com.drimsys.simulator.util;

import com.drimsys.simulator.dto.JSONResult;

/**
 * 자주 사용하는 JSON 관련 유틸
 *
 * @author Gyeongseok Seo
 * @version 1.0
 * @since 2019-11-01 14:08
 */

public class JSONUtil{
    public static JSONResult returnResult(boolean isSaved) {
        if(isSaved) {
            return new JSONResult(200, "OK", null);
        } else {
            return new JSONResult(500, "Bad", null);
        }
    }
}
