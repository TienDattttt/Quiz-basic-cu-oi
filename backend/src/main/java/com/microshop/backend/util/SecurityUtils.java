// src/main/java/com/microshop/backend/util/SecurityUtils.java
package com.microshop.backend.util;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;

import java.util.Map;

public class SecurityUtils {
    public static Integer currentUserId() {
        Authentication a = SecurityContextHolder.getContext().getAuthentication();
        if (a == null) return null;
        Object details = a.getDetails();
        if (details instanceof Map<?,?> map) {
            Object uid = map.get("uid");
            if (uid instanceof Integer i) return i;
            if (uid instanceof Number n) return n.intValue();
        }
        return null;
    }
}
