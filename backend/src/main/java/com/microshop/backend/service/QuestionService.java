package com.microshop.backend.service;

import com.microshop.backend.dto.QuestionDTO;
import java.util.List;

public interface QuestionService {
    QuestionDTO create(QuestionDTO dto);
    List<QuestionDTO> getBySubject(Integer subjectId);
    QuestionDTO getById(Integer id);
    QuestionDTO update(Integer id, QuestionDTO dto);
    void delete(Integer id);
}
