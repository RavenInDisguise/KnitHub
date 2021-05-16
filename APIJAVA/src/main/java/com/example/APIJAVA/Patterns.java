/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.example.APIJAVA;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

/**
 *
 * @author monic
 */
@Entity
public class Patterns {
    @Id
    @GeneratedValue(strategy=GenerationType.IDENTITY)
    private int    patternId;
    private String macaddress;
    private String userName;
    private String lastName;
    private String patternName;
    private String categoryName;
    private String projectName;
    
    public Patterns(){
    }

    public Patterns(String macaddress, String userName, String lastName, String patternName, String categoryName) {
        this.macaddress = macaddress;
        this.userName = userName;
        this.lastName = lastName;
        this.patternName = patternName;
        this.categoryName = categoryName;
    }

    public int getPatternId(){
        return patternId;
    }  

    public void setPatternId(int patternId) {
        this.patternId = patternId;
    }
    
    public String getMacaddress() {
        return macaddress;
    }
      
    public void setMacaddress(String macaddress) {
        this.macaddress = macaddress;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getPatternName() {
        return patternName;
    }

    public void setPatternName(String patternName) {
        this.patternName = patternName;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public String getProjectName() {
        return projectName;
    }

    public void setProjectName(String projectName) {
        this.projectName = projectName;
    }
    
}

