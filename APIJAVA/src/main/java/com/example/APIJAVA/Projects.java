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

/**
 *
 * @author monic
 */
@Entity
public class Projects {
    @Id
    @GeneratedValue(strategy=GenerationType.IDENTITY)
    private int    projectId;
    private String macaddress;
    private String userName;
    private String lastName;
    private String patternName;
    private String projectName;
    private float  pricePerHour;
    
    public Projects(){
    }
   
    public Projects(String macaddress, String userName, String lastName, String patternName, String projectName, float pricePerHour) {
        this.macaddress = macaddress;
        this.userName = userName;
        this.lastName = lastName;
        this.patternName = patternName;
        this.projectName = projectName;
        this.pricePerHour = pricePerHour;
    }
    
    public int getPatternId(){
        return projectId;
    }  

    public void setProjectId(int projectId) {
        this.projectId = projectId;
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

    public String getProjectName() {
        return projectName;
    }

    public void setProjectName(String projectName) {
        this.projectName = projectName;
    }

    public float getPricePerHour() {
        return pricePerHour;
    }

    public void setPricePerHour(float pricePerHour) {
        this.pricePerHour = pricePerHour;
    }
    
}
