package com.microshop.backend.service.impl;

import com.microshop.backend.dto.SubjectDTO;
import com.microshop.backend.entity.Subject;
import com.microshop.backend.repository.SubjectRepository;
import com.microshop.backend.service.SubjectService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class SubjectServiceImpl implements SubjectService {

    private final SubjectRepository subjectRepository;

    @Override
    public SubjectDTO create(SubjectDTO dto) {
        Subject subject = new Subject();
        subject.setSubjectName(dto.getSubjectName());
        subject = subjectRepository.save(subject);

        dto.setId(subject.getId());
        return dto;
    }

    @Override
    public List<SubjectDTO> getAll() {
        return subjectRepository.findAll()
                .stream()
                .map(s -> {
                    SubjectDTO dto = new SubjectDTO();
                    dto.setId(s.getId());
                    dto.setSubjectName(s.getSubjectName());
                    return dto;
                }).toList();
    }

    @Override
    public SubjectDTO getById(Integer id) {
        Subject s = subjectRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Subject not found"));

        SubjectDTO dto = new SubjectDTO();
        dto.setId(s.getId());
        dto.setSubjectName(s.getSubjectName());
        return dto;
    }

    @Override
    public SubjectDTO update(Integer id, SubjectDTO dto) {
        Subject s = subjectRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Subject not found"));
        s.setSubjectName(dto.getSubjectName());
        subjectRepository.save(s);
        dto.setId(id);
        return dto;
    }

    @Override
    public void delete(Integer id) {
        subjectRepository.deleteById(id);
    }
}
