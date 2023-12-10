package com.example.springboottodoapplication.util;

import com.example.springboottodoapplication.models.OrderItem;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

public class VMCreator {
    private OrderItem orderItem;
    private String command;
    private String name;
    private String password;

    public VMCreator(OrderItem orderItem, String name, String password) {
        this.orderItem = orderItem;
        this.name = name;
        this.password = password;
    }

    private String createCommand(){
        command = "onetemplate instantiate ";
        switch(orderItem.getOs()){
            case "debian":
                command += " debian12-password ";
                break;
            case "ubuntu":
                command += " 1737 ";
                break;
            case "fedora":
                command += " fedora39 ";
                break;
            case "centOs":
                command += " centos8 ";
                break;
            default:
                command += " debian12-password ";
        }
        command = command + " --memory " + orderItem.getRam() + " --cpu " + orderItem.getCpu();
        command += " --user " + name + " --name uzsakyta --password \"" + password + "\"  --endpoint https://grid5.mif.vu.lt/cloud3/RPC2";

        return command;
    }

    public void create() {
        createCommand();
        Process p;
        try {
            p = Runtime.getRuntime().exec(new String[]{"bash","-c",command});
            printResults(p);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }
    public static void printResults(Process process) throws IOException {
        BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
        String line = "";
        while ((line = reader.readLine()) != null) {
            System.out.println(line);
        }
    }
}
