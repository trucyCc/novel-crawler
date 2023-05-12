package com.trucy.java.template.em;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public enum TemplateStatusEm {
    TEMPLATE(0, "desc");

    private final Integer status;
    private final String desc;
}
