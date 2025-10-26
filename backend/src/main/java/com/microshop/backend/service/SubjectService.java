package com.microshop.backend.service;

import com.microshop.backend.dto.SubjectDTO;
import java.util.List;

public interface SubjectService {
    SubjectDTO create(SubjectDTO dto);
    List<SubjectDTO> getAll();
    SubjectDTO getById(Integer id);
    SubjectDTO update(Integer id, SubjectDTO dto);
    void delete(Integer id);
}
