package com.govmade.quartz.job;

import org.quartz.Job;
import org.quartz.JobDataMap;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

import com.govmade.entity.system.computer.GovComputerRoom;

public class DataBaseJob implements Job{

	@Override
	public void execute(JobExecutionContext context) throws JobExecutionException {
	    JobDataMap dataMap = context.getJobDetail().getJobDataMap();                   
	    GovComputerRoom data = (GovComputerRoom)dataMap.get("jobData");
        System.out.println(data);
	}

}
