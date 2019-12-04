package com.mckesson.samplek8s.sampleboot.controller;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class SampleController {

  @RequestMapping(method = RequestMethod.GET, path = "/hello")
  public Message helloWorld() {
    return new Message("Hello World!");
  }

  @Getter
  @Setter
  @AllArgsConstructor
  class Message {
    private String message;



  }
}
