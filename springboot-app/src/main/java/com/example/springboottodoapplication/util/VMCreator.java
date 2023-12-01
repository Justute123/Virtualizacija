package com.example.springboottodoapplication.util;

import com.example.springboottodoapplication.models.OrderItem;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

public class VMCreator {
    private OrderItem orderItem;
    private String command;

    public VMCreator(OrderItem orderItem) {
        this.orderItem = orderItem;
    }

    private String createCommand(){
        command = "onetemplate instantiate ";
        switch(orderItem.getOs()){
            case "debian":
                command += " debian12-password ";
                break;
            case "ubuntu":
                command += " ubuntu-22.04 ";
                break;
            case "fedora":
                command += " debian12-password ";
                break;
            case "centOs":
                command += " centos7 ";
                break;
            default:
                command += " debian12-password ";
        }
        command = command + " --memory " + orderItem.getRam() + " --cpu " + orderItem.getCpu();
        command += " --user juur8306 --name automatiskai-sukurta --password \"5f65b771dd2fdc1d232ea35bdbfed020f85e186b\"  --endpoint https://grid5.mif.vu.lt/cloud3/RPC2";

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
