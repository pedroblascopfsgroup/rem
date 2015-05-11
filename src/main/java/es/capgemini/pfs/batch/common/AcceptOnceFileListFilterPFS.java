package es.capgemini.pfs.batch.common;

import java.io.File;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Queue;
import java.util.concurrent.LinkedBlockingQueue;

import org.springframework.integration.file.FileListFilter;

public class AcceptOnceFileListFilterPFS implements FileListFilter{
    
    private final Queue<File> seen;

    private final Object monitor = new Object();
    
    public final List<File> filterFiles(File[] files) {
        List<File> accepted = new ArrayList<File>();
        List<File> tmp =Arrays.asList(files);
        
        for (File file : seen) {
            if(!tmp.contains(file)){
                seen.remove(file);
            }
        }
        if (files != null && files.length >0) {
            for (File file : files) {
                if (this.accept(file)) {
                    accepted.add(file);
                }
            }
        }else{
            //No hay ficheros, todos han sido procesados
            seen.clear();
        }
        return accepted;
    }
    
    
    /**
     * Creates an AcceptOnceFileFilter that is based on a bounded queue. If the
     * queue overflows, files that fall out will be passed through this filter
     * again if passed to the {@link #filterFiles(File[])} method.
     * 
     * @param maxCapacity the maximum number of Files to maintain in the 'seen'
     * queue.
     */
    public AcceptOnceFileListFilterPFS(int maxCapacity) {
        this.seen = new LinkedBlockingQueue<File>(maxCapacity);
    }

    /**
     * Creates an AcceptOnceFileFilter based on an unbounded queue.
     */
    public AcceptOnceFileListFilterPFS() {
        this.seen = new LinkedBlockingQueue<File>();
    }


    protected boolean accept(File pathname) {
        synchronized (this.monitor) {
            if (seen.contains(pathname)) {
                return false;
            }
            if (!seen.offer(pathname)) {
                seen.poll();
                seen.add(pathname);
            }
            return true;
        }
    }

}
