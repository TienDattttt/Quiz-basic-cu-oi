package com.microshop.backend.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
public class ClassroomSimpleResponse {
    private Integer classId;
    private String className;
}
