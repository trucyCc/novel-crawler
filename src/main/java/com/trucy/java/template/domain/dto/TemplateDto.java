package com.trucy.java.template.domain.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.validation.constraints.NotNull;
import java.io.Serializable;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class TemplateDto implements Serializable {
    private static final long serialVersionUID = 1L;

    @Schema(description = "desc")
    @NotNull(message = "msg")
    private String name;

}
