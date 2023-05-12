package com.trucy.java.template.domain.controller;

import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * pos
 */
@Slf4j
@RestController
@AllArgsConstructor
@Tag(name = "POS")
@RequestMapping("/pos")
public class TemplateController {


}
