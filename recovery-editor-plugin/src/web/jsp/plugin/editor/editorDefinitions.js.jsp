editorDef = {};

 
editorDef.simpleEditor = Ext.extend( Ext.Panel, {
    getCondition :  function(){
        return "to be continued...";
    }
    ,initComponent : function(){
        var _self = this;
        this.ruleid=this.initialConfig.ruleid;
        this.radio = new Ext.form.Radio({name:'r_editor',boxLabel : this.initialConfig.titulo }); 
        this.radio.on('focus', function(){
            //XXX uso de variables globales 
            editor.resetAll(_self);
            editor.disableAll();
            editor.setActiveEditor(_self);
            this.enable();
            this.radio.setValue(true);
        },this);

        this.editPanel = new Ext.Panel({
                border: false
                ,autoHeight : true
                ,width : 335
                ,items : this.editorItems
            });

        Ext.applyIf(this,{
            border :  false
            ,autoHeight : true
            ,items : [ this.radio, this.editPanel  ]
            ,bodyStyle : 'padding-top:8px;'
            
        });
        editorDef.simpleEditor.superclass.initComponent.call(this,arguments);
    }


    ,scrollToMakeVisible : function(){
        var parent=this.ownerCt; 
        var offset = this.el.getOffsetsTo(parent.body);
        parent.body.scrollTo("Top", offset[1]);
    }

    ,editCondition :    function(){
        this.radio.setValue(true);
        this.scrollToMakeVisible();
    }

    ,reset :    function(){ this.radio.setValue(false);}

    ,suggestName : function() { return this.initialConfig.titulo; }

    ,getLabel : function(){
        if (this.radio && this.radio.el && this.radio.el.dom) return Ext.get(this.radio.el.dom).next();
    }
    ,enable : function(){
        if(this.getLabel()){ this.getLabel().addClass('bold'); }
         this.enabledisable(false);
    }
    ,disable : function(){
         if (this.getLabel()){ this.getLabel().removeClass('bold');}
         this.enabledisable(true);
    }

    ,enabledisable : function(value){
        var items = this.editorActiveItems || this.editorItems;
         if (items){
             for(var i=0;i < items.length;i++){
                 if (items[i].setDisabled ) items[i].setDisabled(value);
             }
         }
    }

});




editorDef.dictionaryEditor=Ext.extend( editorDef.simpleEditor,{
    initComponent : function(){
    	var values = this.initialConfig.values;
    	var arr=[];
    	for(var i=0;i < values.length;i++){
    		arr.push( [ values[i].id, values[i].desc] );
    	}
        this.checkbox = new Ext.form.Checkbox({style:'margin-top:4px'});
        this.combo = ExtUtil.combo(arr, {width:260});
        this.combo.on("select", function(){ editor.suggestName(); } );
        this.checkbox.on("change", function(){ editor.suggestName(); } );
        var label = new Ext.form.Label({
            text : "No"
            ,style : 'border-right:5px solid white;border-left:5px solid white;padding-top:3px'
    	});
        var panel0 = new Ext.Panel({
        	layout : 'hbox'
        	,border : false
        	,bodyStyle : 'padding:5px'
        	,items :  [ label, this.checkbox]
        });
       
        var panel = new Ext.Panel({
        	layout : 'hbox'
        	,bodyStyle : 'padding:5px'
        	,border : false
        	,items : [ label, this.checkbox, this.combo ]
        });
        this.editorItems = [ panel]
        this.editorActiveItems=[this.combo, this.checkbox];
        editorDef.dictionaryEditor.superclass.initComponent.call(this);
    }

    ,getCondition : function(){
        return {
            operator : this.checkbox.getValue() ? 'notEqual' :'equal'  
            ,values : [ this.combo.getValue() ]
            ,ruleid : this.ruleid
        }
    }

    ,reset : function(){
        editorDef.dictionaryEditor.superclass.reset.call(this);
        this.combo.setValue();
    }

    ,editCondition : function(condition){
        editorDef.dictionaryEditor.superclass.editCondition.call(this,condition);
        if (condition.values!=undefined ){
            try{
                var values = JSON.parse(condition.values);
                this.combo.setValue( values[0] );
            }catch(e){}
        }

    }
    ,suggestName :  function(){
    	var no = this.checkbox.getValue() ? " No " : "";
        return this.initialConfig.titulo + " " +  no + this.combo.getRawValue();
    }
});   

               
editorDef.compare1Editor=Ext.extend( editorDef.simpleEditor,{
    initComponent : function(){
        this.max = new Ext.form.TextField({width:90, style: 'margin-left:10px'});
        this.operator = ExtUtil.combo ([['equal', 'igual'], ['notEqual', 'distinto'],['greaterThan', 'mayor que'],['lessThan', 'menor que']],{width:100, fieldLabel : 'operador'});
        this.editorActiveItems=[this.max,this.operator];
        this.hpanel =   new Ext.Panel({
            border : false
            ,layout :   'hbox'
            ,autoWidth : true
            ,items :[ this.operator, this.max ]
        });
        this.editorItems =  [  {border:false, width:250}, this.hpanel ];
        editorDef.compare1Editor.superclass.initComponent.call(this);
    }

    ,getCondition : function(){
        return {
            operator : this.operator.getValue()
            ,values : [this.max.getValue()]
            ,ruleid : this.ruleid
        }
    }

    ,reset : function(){
        editorDef.compare1Editor.superclass.reset.call(this);
        this.operator.setValue();
        this.max.setValue();
    }

    ,editCondition : function(condition){
        editorDef.compare1Editor.superclass.editCondition.call(this,condition);
        if (condition.values!=undefined ){
            try{
                var values = JSON.parse(condition.values);
                this.operator.setValue(condition.operator);
                this.max.setValue( values[0] );
            }catch(e){}
        }

    }

    ,suggestName : function(){
        return this.initialConfig.titulo + " " + this.operator.getRawValue() + " " + this.max.getValue();
    }
});


editorDef.compare2Editor=Ext.extend( editorDef.simpleEditor,{
    initComponent : function(){
        this.min = new Ext.form.TextField({width:90});
        this.max = new Ext.form.TextField({width:90});
        this.editorActiveItems=[this.min, this.max];
        this.hpanel =   new Ext.Panel({
            border : false
            ,layout :   'hbox'
            ,autoWidth : true
            ,items :[
            	new Ext.form.Label({text:'Entre', style : 'border-right:5px solid white;border-left:5px solid white' })
                ,this.min
                ,new Ext.form.Label({text:'y', style : 'border-right:5px solid white;border-left:5px solid white' })
                ,this.max
            ]
        });
        this.editorItems =  [  {border:false, width:250}, this.hpanel ];
        editorDef.compare2Editor.superclass.initComponent.call(this);
    }

    ,getCondition : function(){
        if (this.min.getValue().length==0 || this.max.getValue().length==0){
        	Ext.MessageBox.alert("Error", "Por favor es necesario introducir valores en el mínimo y máximo");
        	return;
        }
        return {
            operator : 'between'
            ,values : [ this.min.getValue(),this.max.getValue() ]
            ,ruleid : this.ruleid
        }
    }

    ,reset : function(){
        editorDef.compare2Editor.superclass.reset.call(this);
        this.min.setValue();
        this.max.setValue();
    }

    ,editCondition : function(condition){
        editorDef.compare2Editor.superclass.editCondition.call(this,condition);
        if (condition.values!=undefined ){
            try{
                var values = JSON.parse(condition.values);
                this.min.setValue( values[0] );
                this.max.setValue( values[1] );
            }catch(e){}
        }

    }

    ,suggestName : function(){
        return this.initialConfig.titulo + " Entre " + this.min.getValue() + " y entre " + this.max.getValue();
    }
});

editorDef.listEditor=Ext.extend( editorDef.simpleEditor,{
    initComponent : function(){
        this.values =  ExtUtil.list(this.initialConfig.values,{width:350});

        this.panel = new Ext.Panel({
            border : false
            ,items : [ExtUtil.label("tipo"),  this.values]
        });
        Ext.apply(this,{
            items :[this.panel]
        });
        editorDef.listEditor.superclass.initComponent.call(this);
    }

    ,getCondition : function(){
        return {
            operator : this.operator.getValue()
            ,values : [ this.values.getValue() ]
            ,ruleid : this.ruleidField.getValue()
            ,type : this.type.getValue()
        }
    }

    ,reset : function(){
        editorDef.listEditor.superclass.reset.call(this);
        this.type.setValue();
        this.operator.setValue();
        this.ruleidField.setValue();
        this.values.setValue();
    }

    ,editCondition : function(condition){
        editorDef.listEditor.superclass.editCondition.call(this,condition);
        if (condition.values!=undefined ){
            try{
                this.values.setValue(condition.values);
                this.ruleidField.setValue(condition.ruleid);
                this.operator.setValue(condition.operator);
                this.type.setValue(condition.type);
            }catch(e){}
        }
    }

    ,suggestName :  function(){
        return this.initialConfig.titulo + " " + this.operator.getRawValue() + " " + this.combo.getRawValue();
    }
});

editorDef.productoEditor=Ext.extend( editorDef.simpleEditor,{
    initComponent : function(){
        this.linea= ExtUtil.combo( [["1","Activo-Prestamos y Creditos"], ["2","Activo-Avales y Polizas"], ["3","Pasivo- Cuentas"], ["4","Pasivo- Valores"]], {width:200});
        this.grupos =    { a1 : [[10,	"LINEA DESCUENTO COMERCIAL     "], [11,	"LINEA DESCUENTO FINANCIERO    "], [12,	"ANTICIPO CREDITOS COMUNICADOS "], [13,	"PAGARES NO A ORDEN SIN RECURSO"], [14,	"ANTICIPO FACTURAS CON RECURSO "], [15,	"LEASING                       "], [16,	"CONFIRMING CON FINANCIACION   "], [17,	"ANTICIPOS A LA IMPORTACION    "], [18,	"ANTICIPOS A LA EXPORTACION    "], [19,	"CREDITOS                      "], [110,	"TARJETAS DE CREDITO           "], [111,	"TARJETAS DE CRÉDITO           "], [112,	"PRESTAMOS                     "]]
                          ,a2 :[ [20,	"CREDITO DOCUMENTARIO IMPORT.  "], [21,	"CREDITO DOCUMENTARIO EXPORT.  "], [22,	"AVALES Y GARANTIAS EMITIDOS   "], [23,	"AVALES Y GARANTIAS RECIBIDOS  "], [24,	"LINEA AVAL                    "], [25,	"AVAL                          "], [26,	"POLIZA AFIANZAMIENTO          "]]
                          ,a3 :[ [30,	"CUENTA CORRIENTE              "], [31,	"CUENTA DE INTERVENCION        "], [32,	"LIBRETA AHORRO                "], [33,	"LIBRETA PLAZO                 "], [34,	"PLAZOS FIJOS ESTRUCTURADOS    "], [35,	"CUC-DIVIDIDA                  "], [36,	"CUC-NO DIVIDIDA CONTROLADA    "], [37,	"CUC-NO DIVIDIDA NO CONTROLADA "], [38,	"CUENTA MUTUA AJENA            "], [39,	"CAPITAL SOCIAL                "]]
                          ,a4 : [[40,	"VALORES                       "], [41,	"RENTA FIJA REPO               "], [42,	"RENTA FIJA PRIVADA            "], [43,	"PENSIONES                     "], [44,	"DERIVADOS                     "], [45,	"FONDOS INVERSION              "]  ]
                          };


        this.productos = { p10 : [[1,"Anticipo a la importacion",false,false,true], [2,"Aval",false,false,true], [3,"Capital Social",false,false,true], [4,"Certificacion de obra",false,false,true], [5,"Confirming con financ.",false,false,true], [6,"Credito",false,false,true], [7,"Credito dinerario",false,false,true], [8,"Credito dinerario Vdo.",false,false,true], [9,"Credito garantias mixtas",false,false,true], [10,"Credito Gtias. Mix Vdo.",false,false,true], [11,"Credito hipotecario",false,false,true], [12,"Credito hipotecario Vdo.",false,false,true], [13,"Credito personal",false,false,true], [14,"Credito personal Vdo.",false,false,true], [15,"Credito Vdo.",false,false,true], [16,"Cuaderno Bancario 58",false,false,true], [17,"Cuenta corriente",false,false,true], [18,"Cuenta Intervencion",false,false,true], [19,"Cuenta Mutua Agena",false,false,true], [20,"Cuenta Pasivo",false,false,true], [21,"Derivados",false,false,true], [22,"Descuento comercial",false,false,true], [23,"Descuento financiero",false,false,true], [24,"Fondos Inversion",false,false,true], [25,"Leasing",false,false,true], [26,"Libreta Ahorro",false,false,true], [27,"Libreta Plazo",false,false,true], [28,"Linea Aval",false,false,true], [29,"Plazo Fijo Estruct.",false,false,true], [30,"Poliza Afianzamiento",false,false,true], [31,"Prestamo",false,false,true], [32,"Prestamo dinerario",false,false,true], [33,"Prestamo garantia pers.",false,false,true], [34,"Prestamo garantias mixtas",false,false,true], [35,"Prestamo hipotecario",false,false,true], [36,"Renta Fija Repo",false,false,true], [37,"Tarjeta de credito",false,false,true], [38,"Valores",false,false,true], [39,"Descuento comercial Vdo.",false,false,true], [40,"Descuento financiero Vdo.",false,false,true], [41,"Cuaderno Bancario 58 Vdo.",false,false,true]] };

        this.grupo = ExtUtil.combo( [["", "sin datos"]], {width:200});   
        var store = new Ext.data.ArrayStore({
                fields: [
                   {name: 'id'},
                   {name: 'producto'},
                   {name: 'incluir', type: 'bool'},
                   {name: 'excluir', type: 'bool'}
                ]
            });

        var checkColumn1 =   new Ext.grid.CheckColumn({header:"Excluir", dataIndex:'excluir', width:30});
        var checkColumn2 =   new Ext.grid.CheckColumn({header:"Incluir", dataIndex:'incluir', width:30});
        var checkColumn3 =   new Ext.grid.CheckColumn({header:"Ignorar", dataIndex:'ignorar', width:30});
        var cm = new Ext.grid.ColumnModel([
            { id : 'producto', dataIndex : 'producto' }

            ,checkColumn1
            ,checkColumn2
            ,checkColumn3
        ]);

        this.grid= new Ext.grid.EditorGridPanel({
            store: store
            ,cm : cm
            ,plugins: [checkColumn1, checkColumn2, checkColumn3]
            ,stripeRows: true
            ,autoExpandColumn: 'producto'
            ,height:150
            ,clicksToEdit: 1
            ,width:320
        });


        this.linea.on("select", function(){
                this.loadGrupo(this.linea.getValue());
            //this.grupo.getStore().loadData(grupos["a"+this.linea.getValue()]);
        }, this);

        this.grupo.on("select", function(){
            //this.grid.store.loadData(productos["p"+this.grupo.getValue()]);
            this.loadProductos(this.grupo.getValue());
        }, this);


        this.editorItems =  [ExtUtil.label("Linea"), this.linea, ExtUtil.label("Grupo"),this.grupo, ExtUtil.label("tipo"),  this.grid];
        /*
        this.panel = new Ext.Panel({
            border : false
            ,items : [ExtUtil.label("Linea"), this.linea, ExtUtil.label("Grupo"),this.grupo, ExtUtil.label("tipo"),  this.grid]
        });

        Ext.apply(this,{
            items :[this.panel]
        });
        */
        editorDef.productoEditor.superclass.initComponent.call(this);
    }


    ,loadProductos : function(value){
        this.grid.store.loadData(this.productos["p"+value]);
    }

    ,loadGrupo : function(value){
        this.grupo.setValue();
        this.grid.getStore().removeAll();
        this.grupo.getStore().loadData(this.grupos["a"+value]);
    }

    ,getCondition : function(){
        return {
            operator : "tbd"
            ,values : this.getValue()
            ,ruleid : this.initialConfig.ruleid
            ,type : "tbd"
        }
    }

    ,reset : function(){
        this.linea.setValue();
        this.grupo.setValue();
        this.grid.getStore().removeAll();
        
    }

    /* debe poderse restaurar el estado del editor desde este valor*/
    ,getValue : function(){
        var selectedInc=[];
        var selectedExc=[];
        var store= this.grid.getStore();
        var count=store.getCount();
        for(var i=0;i < count;i++){
            var row =   store.getAt(i);
            if (row.get("incluir")) selectedInc.push(row.get("id"));
            if (row.get("excluir")) selectedExc.push(row.get("id"));

        }

        return [   this.linea.getValue(), this.grupo.getValue(), [selectedInc, selectedExc] ];

    }

    ,editCondition : function(condition){
        editorDef.productoEditor.superclass.editCondition.call(this,condition);
        if (condition.values!=undefined ){
            try{
                var v = eval(condition.values);
                var linea=v[0];
                this.linea.setValue(linea);
                this.loadGrupo(linea);
                var grupo=v[1];
                this.grupo.setValue(grupo);
                this.loadProductos(grupo);
                var inc=v[2][0];
                var exc=v[2][1];
                var count=this.grid.getStore().getCount();
                for(var i=0;i < count;i++){
                    var id=this.grid.getStore().getAt(i).get("id");
                    if (inc.indexOf(id)>=0) this.grid.getStore().getAt(i).set("incluir",true);
                    if (exc.indexOf(id)>=0) this.grid.getStore().getAt(i).set("excluir",true);
                }


            }catch(e){}
        }
    }

    ,suggestName :  function(){
        var seleccionados=0;
        var txt="";
        var store= this.grid.getStore();
        var count=store.getCount();
        for(var i=0;i < count;i++){
            if(store.getAt(i).get("incluir") || store.getAt(i).get("excluir")){
                seleccionados++;
                txt = txt+((txt.length>0)? "," : "") + store.getAt(i).get("producto");
            }
            if (seleccionados>3){
                txt =  "varios";
                break;
            }

        }
        return "Tipo producto [" + txt +"]";
    }
});

editorDef.centrosEditor=Ext.extend( editorDef.simpleEditor,{
    initComponent : function(){
        this.nivel= ExtUtil.combo( [["1","Entidad"], ["2","Zona"], ["3","Territorial"] ], {width:200});
        this.centros =    { a1 : [[10,	"Entidad"]]
                          ,a2 :[ [20,	"Zona 1"], [21,	"Zona 2"], [22,	"Zona 3"], [23,	"Zona 4"]]
                          ,a3 :[ [30,	"Territorial1"], [31,	"Territorial2"], [32,	"Territorial3"], [33,	"Territorial4"], [34,	"Territorial5"], [35,	"Territorial6"], [36,	"Territorial7"], [37,	"Territorial8"] ]
                          ,a4 : [[40,	"(seleccionar de la lista)"]]
                          };
        this.salidas =  { 
                             s1 :    [ ["10","Zona"], ["11","Territorial"], ["12","Oficina"]]
                            ,s2 :    [ ["20","Territorial"], ["21","Oficina"]]
                            ,s3 :    [ ["30","Oficina"]]
                            };
        this.centro= ExtUtil.combo( [["",""]], {width:200});
        this.salida= ExtUtil.combo( [["",""]], {width:200});

        function genera(str,num, start){
            var  result=[];
            start = (start==undefined)? 1 : start;
            for(var i=0;i < num;i++){
                result.push( [start+i, str+(start+i), false, false, false] );
            }
            return result;
        }

        this.gridValues = {
                        n1c10s1 : genera("Entidad",4)
                        ,n1c10s10 : genera("Zona",4)
                        ,n1c10s11 : genera("Territorial",8)
                        ,n1c10s12 : genera("Oficina",16)
                        ,n2c20s20 : genera("Territorial", 2,1)
                        ,n2c21s20 : genera("Territorial", 2,3)
                        ,n2c22s20 : genera("Territorial", 2,5)
                        ,n2c23s20 : genera("Territorial", 2,7)
                        ,n2c20s21 : genera("Oficina", 4,1)
                        ,n2c21s21 : genera("Oficina", 4,5)
                        ,n2c22s21 : genera("Oficina", 4,9)
                        ,n2c23s21 : genera("Oficina", 4,13)
                        ,n3c30s30 : genera("Oficina", 2,1)
                        ,n3c31s30 : genera("Oficina", 2,3)
                        ,n3c32s30 : genera("Oficina", 2,5)
                        ,n3c33s30 : genera("Oficina", 2,7)
                        ,n3c35s30 : genera("Oficina", 2,9)
                        ,n3c36s30 : genera("Oficina", 2,11)
                        ,n3c37s30 : genera("Oficina", 2,13)
                            };

        var store = new Ext.data.ArrayStore({
                fields: [
                   {name: 'id'},
                   {name: 'producto'},
                   {name: 'incluir', type: 'bool'},
                   {name: 'excluir', type: 'bool'}
                ]
            });


        this.obtener =  new Ext.Button({text:'obtener', scope : this, handler:function(){
                this.loadGrid(this.nivel.getValue(), this.centro.getValue(), this.salida.getValue());

        }});

        var checkColumn1 =   new Ext.grid.CheckColumn({header:"Excluir", dataIndex:'excluir', width:30});
        var checkColumn2 =   new Ext.grid.CheckColumn({header:"Incluir", dataIndex:'incluir', width:30});
        var checkColumn3 =   new Ext.grid.CheckColumn({header:"Ignorar", dataIndex:'ignorar', width:30});
        var cm = new Ext.grid.ColumnModel([
            { id : 'producto', dataIndex : 'producto' }

            ,checkColumn1
            ,checkColumn2
            ,checkColumn3
        ]);

        this.grid= new Ext.grid.EditorGridPanel({
            store: store
            ,cm : cm
            ,plugins: [checkColumn1, checkColumn2, checkColumn3]
            ,stripeRows: true
            ,autoExpandColumn: 'producto'
            ,height:150
            ,clicksToEdit: 1
            ,width:320
        });


        this.nivel.on("select", function(){
            this.grid.getStore().removeAll();
            this.loadCentro(this.nivel.getValue());
            this.loadSalidas(this.nivel.getValue());
        }, this);

        this.centro.on("select", function(){
            this.grid.getStore().removeAll();
        },this);

        this.salida.on("select", function(){
            this.grid.getStore().removeAll();
        },this);


        this.editorItems =  [ ExtUtil.label("Nivel"), this.nivel, ExtUtil.label("Centro"), this.centro, ExtUtil.label("Salida"), this.salida, this.obtener, ExtUtil.label("Valores"),  this.grid];
        editorDef.centrosEditor.superclass.initComponent.call(this);
    }


    ,loadGrid : function(nivel,centro,salida){
        this.grid.store.loadData(this.gridValues["n"+nivel+"c"+centro+"s"+salida]);
    }

    ,loadSalidas : function(value){
        this.salida.setValue();
        this.salida.getStore().loadData(this.salidas["s"+value]);
    }

    ,loadCentro : function(value){
        this.centro.setValue();
        this.centro.getStore().loadData( this.centros["a"+value] );
    }

    ,getCondition : function(){
        return {
            operator : "tbd"
            ,values : this.getValue()
            ,ruleid : this.initialConfig.ruleid
            ,type : "tbd"
        }
    }

    ,reset : function(){
        this.nivel.setValue();
        this.centro.setValue();
        this.salida.setValue();
        this.grid.getStore().removeAll();
        
    }

    /* debe poderse restaurar el estado del editor desde este valor*/
    ,getValue : function(){
        var selectedInc=[];
        var selectedExc=[];
        var store= this.grid.getStore();
        var count=store.getCount();
        for(var i=0;i < count;i++){
            var row =   store.getAt(i);
            if (row.get("incluir")) selectedInc.push(row.get("id"));
            if (row.get("excluir")) selectedExc.push(row.get("id"));

        }

        return [  this.nivel.getValue(), this.centro.getValue(), this.salida.getValue(), [selectedInc, selectedExc] ];

    }

    ,editCondition : function(condition){
        editorDef.centrosEditor.superclass.editCondition.call(this,condition);
        if (condition.values!=undefined ){
            try{
                /*
                var v = eval(condition.values);
                var linea=v[0];
                this.linea.setValue(linea);
                this.loadGrupo(linea);
                var grupo=v[1];
                this.grupo.setValue(grupo);
                this.loadProductos(grupo);
                var inc=v[2][0];
                var exc=v[2][1];
                var count=this.grid.getStore().getCount();
                for(var i=0;i < count;i++){
                    var id=this.grid.getStore().getAt(i).get("id");
                    if (inc.indexOf(id)>=0) this.grid.getStore().getAt(i).set("incluir",true);
                    if (exc.indexOf(id)>=0) this.grid.getStore().getAt(i).set("excluir",true);
                }

                */

            }catch(e){}
        }
    }

    ,suggestName :  function(){
        var seleccionados=0;
        var txt="";
        var store= this.grid.getStore();
        var count=store.getCount();
        for(var i=0;i < count;i++){
            if(store.getAt(i).get("incluir") || store.getAt(i).get("excluir")){
                seleccionados++;
                txt = txt+((txt.length>0)? "," : "") + store.getAt(i).get("producto");
            }
            if (seleccionados>3){
                txt =  "varios";
                break;
            }

        }
        return "Centro [" + txt +"]";
    }
});

editorDef.genericEditor=Ext.extend( editorDef.simpleEditor,{
    initComponent : function(){
        this.type = ExtUtil.combo([['compare1', 'comparación simple'], ['compare2', 'comparación múltiple'],['date', 'fecha'],['dateTime', 'fecha y hora'],['nullabel','Sin especificar']],{width:300, fieldLabel : 'tipo'});
        this.operator = ExtUtil.combo ([['equal', 'igual'], ['notEqual', 'distinto'],['greaterThan', 'mayor que'],['lessThan', 'menor que'],['between','entre']],{width:300, fieldLabel : 'operador'});
        this.ruleidField =  ExtUtil.combo ([['11', 'Sexo'], ['12', 'Nacionalidad'],['13', 'Tributacion'],['14', 'Edad']],{width:300, fieldLabel : 'operador'});
        this.values =  new Ext.form.TextField({width:300});
        this.sql =  new Ext.form.TextArea({width:300});

        this.editorItems = [ExtUtil.label("tipo"), this.type
                            ,ExtUtil.label("operador"),  this.operator
                            ,ExtUtil.label("id de regla"), this.ruleidField
                            ,ExtUtil.label("valores"), {border:false}, this.values, {border:false}
                            ,ExtUtil.label("SQL libre"), {border:false, width:100},this.sql
                            ];
        /*
        this.panel = new Ext.Panel({
            border : false
            ,items : [ExtUtil.label("tipo"), this.type,ExtUtil.label("operador"),  this.operator,ExtUtil.label("id de regla"),  this.ruleidField, ExtUtil.label("valores"), {border:false}, this.values]
        });
        Ext.apply(this,{
            items :[this.panel]
        });
        */
        editorDef.genericEditor.superclass.initComponent.call(this);
    }

    ,getCondition : function(){
        return {
            operator : this.operator.getValue()
            ,values : [ this.values.getValue() ]
            ,ruleid : this.ruleidField.getValue()
            ,type : this.type.getValue()
        }
    }

    ,reset : function(){
        editorDef.genericEditor.superclass.reset.call(this);
        this.type.setValue();
        this.operator.setValue();
        this.ruleidField.setValue();
        this.values.setValue();
    }

    ,editCondition : function(condition){
        editorDef.genericEditor.superclass.editCondition.call(this,condition);
        if (condition.values!=undefined ){
            try{
                this.values.setValue(condition.values);
                this.ruleidField.setValue(condition.ruleid);
                this.operator.setValue(condition.operator);
                this.type.setValue(condition.type);
            }catch(e){}
        }
    }

    ,suggestName :  function(){
        return this.initialConfig.titulo + " " + this.operator.getRawValue() + " " + this.combo.getRawValue();
    }
});

var filtro = new Ext.form.TextField({ enableKeyEvents : true});

var store =  new Ext.data.JsonStore({
        	root: 'rulesList'
        	//,autoLoad: false
        	,url: '/pfs/editor/loadRules.htm'
        	,fields: ['id','name', 'nameLong']
   		});

editorDef.rulesEditor=Ext.extend( editorDef.simpleEditor,{
    initComponent : function(){
 
 		var cm = new Ext.grid.ColumnModel([
			    {header: 'Nombre', width: 100, sortable: true, dataIndex: 'name'}
			    ,{header: 'Descripcion', width: 200, sortable: true, dataIndex: 'nameLong'}
		]);
        
        
 
 		store.reload();
 
 		var label = new Ext.form.Label({text:'Filtro: ', style : 'margin-right:5px'});
	    filtro.on('keyup', function(){
	                store.filter('name', filtro.getValue(),true,false);
	    });
		this.grid = new Ext.grid.GridPanel({
			title : 'Reglas'
			,cm : cm
			,store : store
        	,autoHeight : true
        	,tbar : [label, filtro]
			,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
		});
		
        this.editorItems = [this.grid];
        editorDef.rulesEditor.superclass.initComponent.call(this);
    }

	,getSelected : function(){
		return this.grid.getSelectionModel().getSelected();
	}

    ,getCondition : function(){
        if (!this.getSelected()){
        	Ext.MessageBox.alert("Error", "Por favor es necesario seleccionar un valor");
        	return;
        }
        filtro.reset();
        store.reload();
       	return {
            operator : ""
            ,ruleid : this.getSelected().get("id")
            ,type : this.initialConfig.type
        }
    }

    ,reset : function(){
        editorDef.rulesEditor.superclass.reset.call(this);
    }

    ,editCondition : function(condition){
        editorDef.rulesEditor.superclass.editCondition.call(this,condition);
        if (condition.ruleid!=undefined ){
            try{
            	var id = JSON.parse(condition.ruleid);
            	var rec=this.grid.getStore().getById(id);
            	this.grid.getSelectionModel().selectRecords([rec]);
            	
            }catch(e){}
        }
    }

    ,suggestName :  function(){
    	if (this.getSelected()){
        	return "link:" + this.getSelected().get("name");
        }else return "seleccione un valor";
    }
});






