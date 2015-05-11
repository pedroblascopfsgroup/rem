package es.capgemini.pfs.test.job.bean;

import es.capgemini.pfs.job.JobRunner;

public class JobTWait implements JobRunner{
    
    private long timeWaite=10000;
    
    
    public JobTWait(long timeWaite) {
        super();
        this.timeWaite = timeWaite;
    }
    
    public JobTWait() {
        super();
    }

    @Override
    public void run() {
        try {
            Thread.sleep(timeWaite);
        } catch (InterruptedException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        
    }
    

}
