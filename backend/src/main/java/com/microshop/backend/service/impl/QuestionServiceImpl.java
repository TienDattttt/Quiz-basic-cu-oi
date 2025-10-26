package com.microshop.backend.service.impl;

import com.microshop.backend.dto.QuestionDTO;
import com.microshop.backend.entity.Question;
import com.microshop.backend.entity.Subject;
import com.microshop.backend.repository.QuestionRepository;
import com.microshop.backend.repository.SubjectRepository;
import com.microshop.backend.service.QuestionService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class QuestionServiceImpl implements QuestionService {

    private final QuestionRepository questionRepo;
    private final SubjectRepository subjectRepo;

    @Override
    public QuestionDTO create(QuestionDTO dto) {
        Subject subject = subjectRepo.findById(dto.getSubjectId())
                .orElseThrow(() -> new RuntimeException("Subject not found"));

        Question q = new Question();
        q.setSubject(subject);
        q.setContent(dto.getContent());
        q.setOptionA(dto.getOptionA());
        q.setOptionB(dto.getOptionB());
        q.setOptionC(dto.getOptionC());
        q.setOptionD(dto.getOptionD());
        q.setCorrectOption(dto.getCorrectOption().charAt(0)); // ✅ convert String -> char
        q = questionRepo.save(q);

        dto.setId(q.getId()); // ✅ getId() thay vì getQuestionId()
        return dto;
    }

    @Override
    public List<QuestionDTO> getBySubject(Integer subjectId) {
        return questionRepo.findBySubject_Id(subjectId)
                .stream()
                .map(q -> {
                    QuestionDTO dto = new QuestionDTO();
                    dto.setId(q.getId());
                    dto.setSubjectId(q.getSubject().getId());
                    dto.setContent(q.getContent());
                    dto.setOptionA(q.getOptionA());
                    dto.setOptionB(q.getOptionB());
                    dto.setOptionC(q.getOptionC());
                    dto.setOptionD(q.getOptionD());
                    dto.setCorrectOption(String.valueOf(q.getCorrectOption())); // ✅ char -> String
                    return dto;
                }).toList();
    }

    @Override
    public QuestionDTO getById(Integer id) {
        Question q = questionRepo.findById(id)
                .orElseThrow(() -> new RuntimeException("Question not found"));

        QuestionDTO dto = new QuestionDTO();
        dto.setId(q.getId());
        dto.setSubjectId(q.getSubject().getId());
        dto.setContent(q.getContent());
        dto.setOptionA(q.getOptionA());
        dto.setOptionB(q.getOptionB());
        dto.setOptionC(q.getOptionC());
        dto.setOptionD(q.getOptionD());
        dto.setCorrectOption(String.valueOf(q.getCorrectOption()));
        return dto;
    }

    @Override
    public QuestionDTO update(Integer id, QuestionDTO dto) {
        Question q = questionRepo.findById(id)
                .orElseThrow(() -> new RuntimeException("Question not found"));

        q.setContent(dto.getContent());
        q.setOptionA(dto.getOptionA());
        q.setOptionB(dto.getOptionB());
        q.setOptionC(dto.getOptionC());
        q.setOptionD(dto.getOptionD());
        q.setCorrectOption(dto.getCorrectOption().charAt(0));
        questionRepo.save(q);

        dto.setId(id);
        return dto;
    }

    @Override
    public void delete(Integer id) {
        questionRepo.deleteById(id);
    }
}
