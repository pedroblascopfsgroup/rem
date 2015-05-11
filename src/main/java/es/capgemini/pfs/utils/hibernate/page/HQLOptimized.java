package es.capgemini.pfs.utils.hibernate.page;
import org.apache.commons.lang.StringUtils;



public class HQLOptimized {
    
    private String[] select;
    private String[] from;
    private String where="";
    private String hql;
    //internal
    private String obj_name="obj_optimized";
    private String obj_hibernate="";
    
    
    public HQLOptimized(String hql){
        this.hql=hql.trim().replaceAll("\\s+", " ");
    }
    
    public boolean canOptimize(){
        //select
        if(hql.toLowerCase().indexOf("select")!=-1){
            select=hql.substring("select".length(),hql.toLowerCase().indexOf("from")).trim().split(",");
            if(select.length>1){
                //No se puede optimizar por tener mas de un componente en el select
                return false;
            }
            if(select[0].indexOf('.')!=-1)
                return false;
        }
        
        //from
        if(hql.toLowerCase().indexOf("where")!=-1){
            from=hql.substring(hql.toLowerCase().indexOf("from")+4,hql.toLowerCase().indexOf("where")).trim().split(",");
          //where
            where=hql.substring(hql.toLowerCase().indexOf("where")+6,hql.length());
        }else{
            from=hql.substring(hql.toLowerCase().indexOf("from")+4,hql.length()).trim().split(",");
        }
        
        //Check obj_name
        if(from[0].split(" ").length>1){
            obj_name=from[0].split(" ")[1];
          //Set obj hibernate
            obj_hibernate=from[0].split(" ")[0];
        }else{
            from[0]=from[0]+" "+obj_name;  
          //Set obj hibernate
            obj_hibernate=from[0];
        }
        
        return true;
        
    }

   
    public String getOptimizedHQL() {
        return getSelect()+" "+getFrom()+getWhere(); 
    }
    
    private String getSelect(){
        if(select==null || select.length==0)
            return "Select "+obj_name+".id";
        else{
            //distinct?
            if(select[0].toLowerCase().indexOf("distinct")!=-1){
                //Tiene distinct
                String s=select[0].replaceAll("distinct", "");
                s=StringUtils.remove(s,'(');
                s=StringUtils.remove(s,')');
                return "Select distinct "+s.trim()+".id ";
            }else{
                //si distinct
                return "Select "+select[0].trim()+".id ";
            }
        }
    }
    
    private String getFrom(){
        String fromR=" From ";
        for (int i=0;i<from.length;i++) {
            fromR+=from[i];
            if(i+1<from.length)
                fromR+=", ";
        }
        return fromR;
    }
    
    private String getWhere(){
        if(where!=null && where.trim().length()>0)
            return " Where "+where;
        return "";
    }
    
    public static void main(String ar[]){
        HQLOptimized a=new HQLOptimized("from Asunto");
        if(a.canOptimize()){
            System.out.println(a.getOptimizedHQL());
        }
        
        HQLOptimized b=new HQLOptimized("from Asunto where 3!=4");
        if(b.canOptimize()){
            System.out.println(b.getOptimizedHQL());
        }
        
        HQLOptimized c=new HQLOptimized("from Asunto asu where 3!=4");
        if(c.canOptimize()){
            System.out.println(c.getOptimizedHQL());
        }
        
        HQLOptimized d=new HQLOptimized("select distinct c from Contrato c , Movimiento mov where 1=1  and mov.contrato = c and mov.fechaExtraccion = c.fechaExtraccion and c.nroContrato like '%1%' and (  c.oficina.zona.codigo like '01%' )");
        if(d.canOptimize()){
            System.out.println(d.getOptimizedHQL());
        }
    }
    
    public String getObjectHibernate(){
        return obj_hibernate;
    }
    
    
    
    

}
