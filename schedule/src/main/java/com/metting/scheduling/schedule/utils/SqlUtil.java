package com.metting.scheduling.schedule.utils;

import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;

import java.io.BufferedReader;
import java.io.FileReader;

public class SqlUtil {

    private static final String directory = "/db/queries/";

    public static String getSql(String path) throws Exception {
        Resource resource = new ClassPathResource(directory + path);
        String pathSql = resource.getURL().getPath();
        BufferedReader bufferedReader = new BufferedReader(new FileReader(pathSql));
        StringBuilder str = new StringBuilder();
        while (bufferedReader.ready()) {
            str.append(bufferedReader.readLine());
        }
        return str.toString();
    }
}
