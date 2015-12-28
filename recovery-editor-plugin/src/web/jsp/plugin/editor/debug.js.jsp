Debug = function(editor){

    this.fields = ["type","title", "operator", "ruleid", "values"];

    this.editor=editor;
    var _self = this;

    var json = new Ext.form.TextArea({id:'textarea', name:'textarea', fieldLabel:'json', height:400, width:'100%'});

    var getText =   function(){
        var text =  editAreaLoader.getValue("textarea");
	  return text?text:json.getValue();
    };

    var setXML = new Ext.Button({
        text:'setXML'
        ,handler : function(){
            canvas.setXML( getText() );
        }
    });

	var editAreaLoader_init = false;
	
    var getXML = new Ext.Button({
        text:'getXML'
        ,handler : function(){
        	//console.debug(canvas.getXML());
            json.setValue(canvas.getXML());
            if (!editAreaLoader_init) {
            	editAreaLoader.init({ id:"textarea", "syntax":'xml', start_highlight:true});
            	editAreaLoader_init=true
            } else {
            	editAreaLoader.setValue("textarea",json.getValue());
            }
        }

    });


	/*
    var exec = new Ext.Button({
        text : 'ejecutar'
        ,scope : this
        ,handler : function(){
            
		var xml="";
           Ext.Ajax.request({
                url : "/pfs/ruleengine/ruleExecute.htm"
                ,params : { ruleDefinition : getText() }
                ,success :  function(data){
                    var data =  Ext.decode(data);
                    Ext.MessageBox.show("Resultado de la ejecución : " + data.rowsModified);
                }
               });
        }
    });
    */

    //AOP for debug
  //  this.editor.editCondition=this.editor.editCondition.createInterceptor( this.editCondition,this);

    Debug.superclass.constructor.call(this,{
        title : 'Editor'
        ,region : 'south'
        ,bodyStyle:'padding:10px;'
	,height : 400
        ,collapsible : true
        ,collapsed : true
        ,tbar : [  setXML, getXML/*, exec*/]
        ,items : [ json]
    });
};

Ext.extend(Debug, Ext.Panel, {
    editCondition : function(condition){
        var _self=this;
        Ext.each(this.fields, function(f){ _self.form.findField(f).reset(); });
        /*
        Ext.each(node.attributes, function(attr){
            if (attr.name){
                var fld=_self.form.findField(attr.name);
                if (fld){
                    fld.reset();
                    fld.setValue(attr.value);
                }
            }
        });
        */
        var name;
        for( name in condition){
            var fld=_self.form.findField(name);
            if (fld){
                fld.reset();
                fld.setValue(condition[name]);
            }
            
        }
    }

    ,getValue : function(){

        var result = {};
        Ext.each(this.fields, function(f){
            var fld = this.form.findField(f).getValue();
            if (fld){
                result[f]=fld;
            }

        },this);
        return result;
    }

});

$a=function(node){
    var node=Ext.get(node);
    while(node){
        if (node.id && node.id.indexOf("ext-comp")>=0) return Ext.getCmp(node.id);
        if(node) node=node.parent();
        if(node==document) return;
    }

}
