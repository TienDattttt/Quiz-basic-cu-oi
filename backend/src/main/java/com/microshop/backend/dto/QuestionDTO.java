package com.microshop.backend.dto;

import lombok.Data;

@Data
public class QuestionDTO {
    private Integer id;
    private Integer subjectId;
    private String content;
    private String optionA;
    private String optionB;
    private String optionC;
    private String optionD;
    private String correctOption;
}
