package com.microshop.backend.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class ClassroomResponse {
    private Integer studentId;
    private String fullName;
    private String username;
    private String email;
    private Boolean enabled;
}
