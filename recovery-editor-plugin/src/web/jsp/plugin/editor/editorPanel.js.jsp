Editor = function(editorDefinitions){

	editorDefinitions.sort(function(a,b) {
    	var x = a.titulo.toLowerCase();
    	var y = b.titulo.toLowerCase();
    	return x < y ? -1 : x > y ? 1 : 0;
	});
	
	editors=[];
	this.activeEditor=null;
	for(var i=0;i<editorDefinitions.length;i++){
		var def = editorDefinitions[i];
		if (editorDef[def.type]) {
			editors.push( new editorDef[def.type](def) );
		}
	}

	editors.push(
		new editorDef.rulesEditor({titulo : 'Enlazar regla', tab:'Reglas', type: 'link'})
	);


    this.editors=editors; //editores registrados
	this.disableAll();
	
    this.titleField = new Ext.form.TextField({ 
        width:250
        ,fieldLabel : "titulo"
        ,name :  "titulo"
        ,enableKeyEvents : true
    });

    /*
    this.titleField.on('keyup', function(){
                this.fireEvent("setCondition", this.getCondition() );
    },this);
    */


    function editor(texto){
        return  new Ext.Panel({
        layout : 'hbox'
        ,border : false
        ,items : [
            new Ext.form.Radio()
            ,new Ext.form.Label({text : texto,width:60})
            ,ExtUtil.combo( [[1, '>'], [2, '<']])
            , new Ext.form.TextField()]

    	});
    }

    var tabNames =  {};
    Ext.each(this.editors, function(e){
            if (!tabNames[e.tab]) tabNames[e.tab]=[];
            tabNames[e.tab] = tabNames[e.tab].concat( e );
    });

    this.tabs =  [];
    for(var t in tabNames){
        this.tabs.push( new Ext.Panel({
            id : t
            ,title : t
            ,items : tabNames[t]
            ,autoHeight : true
            ,enableTabScroll : true
            //,autoScroll : true
            ,viewConfig: {
                    overflowX: 'auto',
                    overflowY: 'scroll'
             }
            //,layout: 'fit'
            //,overflowY: 'scroll'
            ,bodyStyle : 'padding-left : 5px;padding-bottom:10px'
        }));
    }

     var suggestName = new Ext.Button({
        text : 'Sugerir nombre'
        ,scope : this
        ,handler : this.suggestName
    });
    
    var clearName = new Ext.Button({
        text : 'Borrar'
        ,scope : this
        ,handler : function(){
              this.titleField.setValue()
        }
    });

    var accept = new Ext.Button({
        text :  'Aceptar'
        ,scope : this
        ,icon : '../img/plugin/editor/ok.gif'
        ,handler : function(){
            if (this.titleField.getValue()==""){
              this.titleField.setValue(this.suggestName())
            }
            var condition = this.getCondition();
            if(condition){
            	this.fireEvent("setCondition", condition );
            }
        }
    });


    this.tabsPanel = new Ext.TabPanel({
        autoHeight : false
        ,enableTabScroll : true
        ,autoScroll : true
        ,activeTab : 0
        ,items :[ this.tabs ]
    });


    var botones =   new Ext.Panel({
        border : false
        ,items : [ accept ,suggestName ,clearName]
        ,layout : 'hbox'
    });
    
    var tituloPanel =   new Ext.Panel({
        border : false
        ,items : [this.titleField, accept ]
        ,layout : 'hbox'
    });
    
    var generalPanel = new Ext.Panel({
        border : false
        ,bodyStyle : 'padding : 5px'
        ,items : [
            tituloPanel
            ,botones
        ]
    });

   
    


    
    this.reg =   ExtUtil.combo([
            ['<div class="box condicion" type="compare1" ruleid="0" operator="equal" values=["1"] title="regla generica">regla generica</div>', 'generica']
            ,['<div class="and" title="Hombre joven"><a href="#" class="titulo_paquete">Hombre joven</a><div class="box condicion" type="compare1" ruleid="11" operator="equal" values=["1"] title="es Hombre">es Hombre</div><div class="andSeparator"></div><div class="box condicion" type="compare1" ruleid="14" operator="equal" values=["1","30"] title="menor de 30">menor de 30</div></div>', 'Hombre joven']
            ],{width:280});
            
    var importButton = new Ext.Button({
        text : 'importar regla'
        ,scope : this
        ,handler : function(){
            //aberracion, cambiar
            canvas.importRule(this.reg.getValue());
        }
    });
    
    this.reglas = new Ext.Panel({
        title : 'reglas'
        ,bodyStyle : 'padding : 5px'
        ,items : [this.reg, importButton]
    });

    var rules = new Ext.form.FormPanel({
        items : [
            generalPanel
            ,this.tabsPanel
        ]
    });

    var items = [ rules ];





    Editor.superclass.constructor.call(this,{
        region : 'west'
        ,width : 365
        //,autoHeight : true
        ,autoScroll : true
        ,split : true
        ,title : 'Editor de reglas'
        ,collapsible : true
        ,items : items
        //,tbar : [ accept  ]
    });

    this.addEvents({
        setCondition : true
    });
};

Ext.extend(Editor, Ext.Panel, {
    editCondition : function(condition){
    //console.debug(condition);
        //aqui va el codigo para seleccionar el editor adecuado

        this.titleField.setValue(condition.title);
        
        this.resetAll();
        this.disableAll();
		
        var editor = this.findEditor(condition);
        this.setActiveEditor(editor);
        if (editor){
        	editor.enable();
        	if (editor.tab){
            	this.tabsPanel.activate(editor.tab);
        	}
         	editor.editCondition(condition);
         } 
    }
	
	,setActiveEditor : function(editor){
		this.activeEditor = editor;
	}

    ,findEditor : function(condition){
      	//si tenemos type, primero vamos a buscar por tipo, para editores "especiales"
      	if (condition.type) {
      		for(var i=0;i < this.editors.length;i++){
      			if (this.editors[i].type && this.editors[i].type==condition.type){
      				return this.editors[i];
      			}
      		}
        }
      	
        for(var i=0;i < this.editors.length;i++)
            if (this.editors[i].ruleid!=undefined && this.editors[i].ruleid==condition.ruleid){ return this.editors[i]; }
        //devolvemos el editor generico
        return;
    }

    ,setCondition : function(condition){
        this.fireEvent("setCondition", condition);
    }

    ,registerEditor : function(editor){
    }

    ,getActiveEditor :  function(){
       return this.activeEditor;
       // for(var i=0;i < this.editors.length;i++){
       //     if (this.editors[i].radio.checked) { return this.editors[i]; }
       // }
    }

    ,disableAll : function(notMe){
        Ext.each(this.editors, function(ed){ if (ed!=notMe) ed.disable();} );
    }

    ,resetAll : function(notMe){
        Ext.each(this.editors, function(ed){ if (ed!=notMe) ed.reset();} );
    }

    ,getCondition : function(){
        var condition = { title:this.titleField.getValue() };
        if (this.getActiveEditor()){
            Ext.apply(condition,this.getActiveEditor().getCondition());
        }
        return condition;
        
    }

    ,suggestName : function(){
    	var txt="{sin nombre}";
        if (this.getActiveEditor() &&   this.getActiveEditor().suggestName ){
            txt = this.getActiveEditor().suggestName();
        }
        this.titleField.setValue(txt);
    }
});
Ext.reg('editorpanel',Editor);



