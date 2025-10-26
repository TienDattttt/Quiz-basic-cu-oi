package com.microshop.backend.dto;

import lombok.Data;

@Data
public class ExamHistoryDetailResponse {
    private Integer questionId;
    private String content;
    private String optionA;
    private String optionB;
    private String optionC;
    private String optionD;
    private String chosenOption;
    private String correctOption;
    private boolean correct;
}
