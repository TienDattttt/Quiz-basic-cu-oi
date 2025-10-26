package com.microshop.backend.dto;

import lombok.Data;

@Data
public class ExamCreateRequest {
    private Integer subjectId;
    private String title;
}
