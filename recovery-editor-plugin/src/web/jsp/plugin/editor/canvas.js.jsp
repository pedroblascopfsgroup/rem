<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>

Ext.util.base64 = {

    base64s : "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/",
    
    encode: function(decStr){
        if (typeof btoa === 'function') {
             return btoa(decStr);            
        }
        var base64s = this.base64s;
        var bits;
        var dual;
        var i = 0;
        var encOut = "";
        while(decStr.length >= i + 3){
            bits = (decStr.charCodeAt(i++) & 0xff) <<16 | (decStr.charCodeAt(i++) & 0xff) <<8 | decStr.charCodeAt(i++) & 0xff;
            encOut += base64s.charAt((bits & 0x00fc0000) >>18) + base64s.charAt((bits & 0x0003f000) >>12) + base64s.charAt((bits & 0x00000fc0) >> 6) + base64s.charAt((bits & 0x0000003f));
        }
        if(decStr.length -i > 0 && decStr.length -i < 3){
            dual = Boolean(decStr.length -i -1);
            bits = ((decStr.charCodeAt(i++) & 0xff) <<16) |    (dual ? (decStr.charCodeAt(i) & 0xff) <<8 : 0);
            encOut += base64s.charAt((bits & 0x00fc0000) >>18) + base64s.charAt((bits & 0x0003f000) >>12) + (dual ? base64s.charAt((bits & 0x00000fc0) >>6) : '=') + '=';
        }
        return(encOut);
    },
    
    decode: function(encStr){
        if (typeof atob === 'function') {
            return atob(encStr); 
        }
        var base64s = this.base64s;        
        var bits;
        var decOut = "";
        var i = 0;
        for(; i<encStr.length; i += 4){
            bits = (base64s.indexOf(encStr.charAt(i)) & 0xff) <<18 | (base64s.indexOf(encStr.charAt(i +1)) & 0xff) <<12 | (base64s.indexOf(encStr.charAt(i +2)) & 0xff) << 6 | base64s.indexOf(encStr.charAt(i +3)) & 0xff;
            decOut += String.fromCharCode((bits & 0xff0000) >>16, (bits & 0xff00) >>8, bits & 0xff);
        }
        if(encStr.charCodeAt(i -2) == 61){
            return(decOut.substring(0, decOut.length -2));
        }
        else if(encStr.charCodeAt(i -1) == 61){
            return(decOut.substring(0, decOut.length -1));
        }
        else {
            return(decOut);
        }
    }

}; 


var deshabilitarItems = function(items,disabled) {
	items.each(function(item,index,length){
   		if (item.key != undefined && item.key == "isDisabled") {
   			item.setDisabled(disabled);
   		}
   		if (item.menu != undefined) {
   			var menu = item.menu.items;
   			deshabilitarItems(menu,disabled);
   		}
   	});
};

Canvas = function(){

    this.fields =  ["type","title", "operator", "ruleid", "values"];
    
    var reopen;
    var w;
    var arquetipo = {};
    
    this.getArquetipo = function(){
    	return arquetipo;
    }
    
    this.setArquetipo = function(id,name,nameLong){
    	arquetipo.id=id;
    	arquetipo.name=name;
    	arquetipo.nameLong=nameLong;
    	arquetipo.bloque=0;
    	arquetipo.modificado=false;
    	if (window.canvas && canvas.setTitle) canvas.setTitle(name);
    };
    
    this.arquetipoModificado = function(){
    	arquetipo.modificado=true;
    }
    
    this.resetArquetipo = function(){
    	this.setArquetipo(null, "Nuevo arquetipo", "Nuevo arquetipo");
    }
    
    this.getBlockName = function(){
    	var id = arquetipo.bloque;
    	arquetipo.bloque=id+1;
    	return "bloque " + id;
    }
    
    this.resetArquetipo();
    
    this.disableTopToolbar = function(disabled,editable) {
    	if (!editable) {
    		canvas.setTitle(canvas.title + ' (Regla sólo lectura)');
    	}    	    	
    	var btTopToolbar = this.getTopToolbar().items;
    	deshabilitarItems(btTopToolbar,disabled);    	
    };
        
    
    var restart =  {
        text:"Nuevo"        
        ,scope : this
        ,icon : '../img/plugin/editor/page.gif'
        ,handler : function(){
            this.restart();
            canvas.setTitle('<s:message code="editorPaquetes.nuevo" text="**Nuevo paquete" />');
        }
    };

    var addY =  new Ext.Button({
        text:"<s:message code="editorPaquetes.condicionY" text="**Condición Y" />"
        ,scope : this
        ,icon : '../img/plugin/editor/button_y.gif'
        ,handler : function(){
            this.addElement(this.addAnd);
            if (isRelacionesActivas) mostrarRelaciones();            
        }
        ,key : 'isDisabled'
    });
    var addO =  new Ext.Button({
        text:"<s:message code="editorPaquetes.condicionO" text="**Condición O" />"
        ,scope : this
        ,icon : '../img/plugin/editor/button_o.gif'
        ,handler : function(){
            this.addElement(this.addOr);
            if (isRelacionesActivas) mostrarRelaciones();                        
        }
        ,key : 'isDisabled'
    });

    var remove =  new Ext.Button({
        text:"<s:message code="editorPaquetes.eliminar" text="**Eliminar" />"
        ,icon : '../img/plugin/editor/button_remove.gif'
        ,scope : this
        ,handler : function(){
            this.removeElement(this.getSelected());
        }
        ,key : 'isDisabled'
    });


	var isRelacionesActivas = false;

	var ocultarMostrarRelaciones = function(btn,item){	
		if (!isRelacionesActivas){
			this.setText("<s:message code="editorPaquetes.ocultarRelaciones" text="**Ocultar relaciones" />");
			isRelacionesActivas = true;
			mostrarRelaciones();
		}else{
			this.setText("<s:message code="editorPaquetes.verRelaciones" text="**Ver relaciones" />");
			isRelacionesActivas = false;
			mostrarRelaciones();
		}
	};


	var mostrarRelaciones = function(){
		if (isRelacionesActivas ){
			Ext.select('.andSeparator').addClass('andSeparatorExtended');
			Ext.select('.orSeparator').addClass('orSeparatorExtended');
		}else{
			Ext.select('.andSeparatorExtended').removeClass('andSeparatorExtended');
			Ext.select('.orSeparatorExtended').removeClass('orSeparatorExtended');
		}
	};

    var viewRelations = new Ext.Button({
         text : "<s:message code="editorPaquetes.verRelaciones" text="**Ver relaciones" />"
         ,icon : '../css/eye.gif'
        ,handler : ocultarMostrarRelaciones
    });
    
    
    /*var rulesListStoreXXX = new Ext.data.JsonStore({
	    	data: rulesList
	    	,fields: ['id','name']
	});*/
	
	// Store
    var rulesListStore = new Ext.data.JsonStore({
        autoLoad: false
        ,root: 'rulesList'
        ,url: '/pfs/editor/loadRules.htm'
        ,fields: ['id','name','nameLong']
    });
	
	
	var rulesListCM = new Ext.grid.ColumnModel([
	   // {header: 'ID', width: 60, sortable: true, dataIndex: 'id'}
	    {header: '<s:message code="editorPaquetes.cabeceraNombre" text="**Nombre" />', width: 200, sortable: true, dataIndex: 'name'}
	    ,{header: '<s:message code="editorPaquetes.cabeceraDescripcion" text="**Descripcion" />', width: 300, sortable: true, dataIndex: 'nameLong'}
	]);
    
	var ventanaGenerica = function(titulo, fn){
		rulesListStore.reload();
		
		 var cancelar =  new Ext.Button({ text:'<s:message code="editorPaquetes.cancelar" text="**Cancelar" />', handler : function(){ filtro.reset();w.hide(); }});
		 
		 var fnAceptar = function(){
			 var id= rulesListGrid.getSelectionModel().getSelected().get("id");
			 if (id == undefined){
			 	rulesListGrid.getSelectionModel().select(0);
			 	id= rulesListGrid.getSelectionModel().getSelected().get("id");
			 }
			 filtro.reset();
			 w.hide();
			 fn(id);
		 }; 
		 
		 var aceptar =  new Ext.Button({ text:'<s:message code="editorPaquetes.aceptar" text="**Aceptar" />', handler : fnAceptar });
         var label = new Ext.form.Label({text:'<s:message code="editorPaquetes.filtro" text="**Filtro :" />'});
         var filtro = new Ext.form.TextField({ enableKeyEvents : true});
         filtro.on('keyup', function(){
             rulesListStore.filter('name', filtro.getValue(),true,false);
         });
	     var rulesListGrid= new Ext.grid.GridPanel({	
				frame:false 
				,border:false
				,loadMask: {msg: "<s:message code="editorPaquetes.cargando" text="**Cargando..." />", msgCls: "x-mask-loading"}
				,store: rulesListStore
				,cm:rulesListCM
			    ,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
             ,autoWidth : true
             ,height:200
             ,bbar : [aceptar, cancelar]
             ,tbar : [label, filtro]
			});

			rulesListGrid.on('rowdblclick',fnAceptar );
     		
    		w = openWindow({
				title:titulo
				,width:600
				,autoHeight : true
                ,autoScroll:true
				,closable:true
				,items:rulesListGrid
				,x:300
				,y:200
			}); 
	};
	
    var open={
			text:'<s:message code="editorPaquetes.abrir" text="**Abrir" />'
			,icon : '../css/folder_page.gif'
	        ,handler:function(){
	        	var abrir=function(){
	        		ventanaGenerica('Abrir regla' , function(id){
    					 		Ext.Ajax.request({
    		 						url : '/pfs/editor/loadRule.htm'
    		 						,params : {id : id}
    		 						,success : function(response){
    		 							var datos = Ext.decode(response.responseText);
    		 							canvas.setXML(datos.xml);		
    		 							canvas.setArquetipo(datos.id, datos.name, datos.nameLong);
    									var editable = datos.editable;
    									if (!editable){
    										canvas.disableTopToolbar(true,editable);
    									} else {
    										canvas.disableTopToolbar(false,editable);
    									}
    									
    		 						}
    							});	
    						});
	        	}
	        	if (canvas.getArquetipo().modificado){
	        		Ext.MessageBox.confirm("<s:message code="editorPaquetes.abrirConfirmacion" text="**Abrir arquetipo" />", "<s:message code="editorPaquetes.abrirConfirmacionTxt" text="**El arquetipo ha cambiado, está seguro de que desea descartar los cambios y abrir uno nuevo?" />", 
	        		function(respuesta){
	        			if (respuesta=='yes'){ 
	        				abrir();
	        			} 
	        		});
	        	}else{
	        		if(reopen){
	        			rulesListStore.reload();
						w.show();
	        		} else {
	        			abrir();
	        			reopen = true;
	        		}
	        	}
    			
    		}
	};
    
    var importar = {
    	text : '<s:message code="editorPaquetes.importar" text="**Importar" />'
    	,icon : '../css/table_row_insert.gif'
    	,key : 'isDisabled'
    	,handler : function(){
    		if (!canvas.getSelected()){
    			Ext.MessageBox.alert("<s:message code="editorPaquetes.reglaNoSeleccionada" text="**Debe seleccionar un elemento donde importar la regla" />");
    			return;
    		}
    		ventanaGenerica( '<s:message code="editorPaquetes.tituloVentanaImportar" text="**Importar regla" />', function(id){
    			 Ext.Ajax.request({
    					url : '/pfs/editor/loadRule.htm'
    					,params : {id : id}
    					,success : function(response){
    						var datos = Ext.decode(response.responseText);
    						canvas.importRuleXml(datos.xml);
    						var editable = datos.editable;
							if (!editable){
    							canvas.disableTopToolbar(true,editable);
    						} else {
    							canvas.disableTopToolbar(false,editable);
    						}
    								
    					}
    			});
    		});
    	}
    };
    
    
    
    var del = {
    	text : '<s:message code="editorPaquetes.borrar" text="**Borrar" />'
   		,icon : '../css/false.gif'
   		,key : 'isDisabled'
		,handler : function(){
			Ext.MessageBox.confirm("<s:message code="editorPaquetes.borrarConfirmar" text="**Confirmación de borrado de regla" />", "<s:message code="editorPaquetes.borrarConfirmarTxt" text="**¿Está seguro de que desea borrar esta regla?" />", function(resp){
				if (resp=='no') return;
				if(!canvas.getArquetipo().id) {
					Ext.Msg.alert('<s:message code="editorPaquetes.alertaGuardar" text="**Guardar" />','<s:message code="editorPaquetes.alertGuardarTxt" text="**La regla no ha podido guardarse." />'); 
					canvas.restart();
					return;
				}
				Ext.Ajax.request({
					url : '/pfs/editor/deleteRule.htm'
					,params : {id : canvas.getArquetipo().id}
		    		,success : function(response){
		    			canvas.restart();		
		    		}
				});
			});
		}
    };
    
    var fnGuardar = function(id, name, nameLong){
    	var ruleDefinitionBase64 = Ext.util.base64.encode(canvas.getXML());
    	Ext.Ajax.request({
			url : '/pfs/editor/saveRule.htm'
			,params : { id:id, name: name,nameLong:nameLong, ruleDefinition : ruleDefinitionBase64 }
			,success : function(response){
				var data = Ext.decode(response.responseText);
				if (!data.success){
					Ext.Msg.alert('<s:message code="editorPaquetes.alertaGuardar" text="**Guardar" />','<s:message code="editorPaquetes.alertGuardarTxt" text="**La regla no ha podido guardarse." />'); 
					return;
				}
				canvas.setArquetipo(data.result, name, nameLong);
				Ext.Msg.alert('<s:message code="editorPaquetes.alertaGuardar" text="**Guardar" />', '<s:message code="editorPaquetes.alertaGuardarOk" text="**La regla ha sido guardada correctamente." />'); 
			}
		});
    };
    	
    
    var save = {
    	text : '<s:message code="editorPaquetes.guardar" text="**Guardar" />'
    	,icon : '../css/tick.gif'
    	,key : 'isDisabled'
    	,handler : function(){
	    	if(canvas.getArquetipo().id==null){
	    		var name = new Ext.form.TextField({ fieldLabel : '<s:message code="editorPaquetes.campoNombre" text="**Nombre" />', width:200, allowBlank:false	});
	    		var nameLong = new Ext.form.TextArea({ fieldLabel : '<s:message code="editorPaquetes.campoDescripción" text="**Descripción" />', width: 200	});
	    		var aceptar = new Ext.Button({text:'Aceptar', handler: function(){
	    			if (name.getValue().length>0){
	    				fnGuardar(null,name.getValue(),nameLong.getValue());
	    				w.close();
	    			}else{
	    				Ext.MessageBox.alert("<s:message code="editorPaquetes.alertaError" text="**Error" />", "<s:message code="editorPaquetes.introducirNombre" text="**Debe introducir un nombre" />");
	    			}
	    		}});
	    		var cancelar = new Ext.Button({text:'<s:message code="editorPaquetes.cancelar" text="**Cancelar" />', handler: function(){ w.close(); }});
	    		var panel = new Ext.form.FormPanel({
	    			border : false
	    			,bodyStyle : 'padding:8px'
	    			,height : 150
	    			,items : [name, nameLong]
	    			,bbar : [aceptar, cancelar]
	    		});
	    		
		    	var w = openWindow({
					title:"<s:message code="editorPaquetes.guardarRegla" text="**Guardar regla" />"
					,width:500
					,autoHeight : true
					,height : 100
		            ,autoScroll:true
					,closable:true
					,resizable : true
					,items:[panel]
					,x:300
					,y:200
				}); 
		    	
	    	}else{
	    		fnGuardar(canvas.getArquetipo().id,canvas.getArquetipo().name,canvas.getArquetipo().nameLong);
	    	}
    	}
    };

	var exec = new Ext.Button({
        text : '<s:message code="editorPaquetes.ejecutar" text="**Ejecutar" />'
        ,icon : '../css/refresh.gif'
        ,scope : this
        ,handler : function(){
           msgEspere=Ext.MessageBox.wait("<s:message code="editorPaquetes.espere" text="**Espere" />","<s:message code="editorPaquetes.calculandoRegla" text="**Calculando regla" />")
           var ruleDefinitionBase64 = Ext.util.base64.encode(canvas.getXML());
           Ext.Ajax.request({
                url : "/pfs/editor/checkRule.htm"
				,scope : this
                ,params : { ruleDefinition : ruleDefinitionBase64 }
                ,success :  function(response){
                	msgEspere.hide();
                    var data =  Ext.decode(response.responseText);
                    if(data.rowsModified==-1){
	                    Ext.MessageBox.show({
                    					 title: "<s:message code="editorPaquetes.error" text="**Error" />",
                    					 msg: "<s:message code="editorPaquetes.reglaMal" text="**Ha ocurrido un error al ejecutar la regla. <br/> Verifíquela!" />",
                    					 buttons: Ext.Msg.OK,
                    					 icon: Ext.MessageBox.ERROR,
							 width: 300
                    					 }
                    					 );
                    }else{
				Ext.MessageBox.show({
                    					 title: "<s:message code="editorPaquetes.resultadoRegla" text="**Resultado de la ejecucion" />",
                    					 msg:  data.rowsModified + " <s:message code="editorPaquetes.elementosCumplen" text="**elementos cumplen la regla" />",
                    					 buttons: Ext.Msg.OK,
                    					 icon: Ext.MessageBox.INFO,
							 width: 300
                    					 }
                    					 );

                    }
                    	
                }
               });
        }
    });


    this.snipplets =    {
        o : '<div class="orSeparator"></div><div class="box condicion">{editar}</div>'
        ,or : '<div class="or"></div>'
        ,and : '<div class="and"></div>'
        ,y : '<div class="andSeparator"></div><div class="box condicion">{editar}</div>'
    };



    var regla = {    		
    		text : '<s:message code="editorPaquetes.paquete" text="**Paquete" />'
    		,menu : [restart,open, save, importar, del]
    };
    

    Editor.superclass.constructor.call(this,{
        region : 'center'
        ,title : '<s:message code="editorPaquetes.nuevoPaquete" text="**Nuevo paquete" />'
        ,autoScroll : true
        ,html : '<div id="esquema"> </div>'
        ,tbar : [regla, exec,'-', addY,addO,remove,'-',viewRelations]

    });

    this.addEvents({
        conditionSelected : true
    });

    this.on('redraw',this.redraw,this);
};

Ext.extend(Canvas, Ext.Panel,{

        ROOT_NODE :  'esquema'
        ,SELECTED : 'condition_selected'
        ,CLASS_SELECTED : '.condition_selected'

        ,redraw : function(){
        }

        ,setSelected : function(node){
            this.removeSelected();
            Ext.fly(node).addClass(this.SELECTED);
        }

        ,getSelected : function(){
            return Ext.get(Ext.query(this.CLASS_SELECTED)[0]);
        }

        ,handler_titulo_paquete : function(event){
                var otherNodes = Ext.get(this.parentNode).query("*").slice(1);
                //Ext.get(Ext.get(this.parentNode).query("*").slice(1)).setDisplayed(otherNodes);
                Ext.get(otherNodes).setDisplayed(!Ext.fly(otherNodes[0]).isDisplayed());
                event.stopEvent();
        }
            

        ,initHandlers : function(root){
            var el = Ext.get( root || document);
            var _self = this;
            el.select('.condicion, .and, .or').removeAllListeners();

            el.select('.condicion, .and, .or, .link').on('click', function(event){
                _self.clickCondition.call(_self,this);
                event.stopEvent();
            });

            el.select('.titulo_paquete').removeAllListeners();
            el.select('.titulo_paquete').on('dblclick', this.handler_titulo_paquete);
        }


        ,removeSelected : function(){
            Ext.select(this.CLASS_SELECTED).removeClass(this.SELECTED);
        }
        ,clickCondition : function(node){
            this.setSelected(node);
            //convert node -> javascript object
            var object={};
            for(var i=0;i < node.attributes.length;i++){
                object[node.attributes[i].name]=node.attributes[i].value;
            }
            window.ob=object;
            this.fireEvent('conditionSelected',object);

            
        }
        ,toJSONCondition : function (nodo){
            var condicion = {};
            for(var i=0;i < this.fields.length;i++){
                var f = this.fields[i];
                if (Ext.fly(nodo).getAttribute(f)){
                    condicion[f] =   Ext.fly(nodo).getAttribute(f);
                    //maybe it's a number/boolean/array
                    try{
                        condicion[f] =   JSON.parse(Ext.fly(nodo).getAttribute(f));
                    }catch(e){}
                }

            }
            return condicion;
        }

        ,cleanArray : function(arr){
            var result =  [];
            var i=0;
            for(i=0;i < arr.length;i++){
                result.push(arr[i]);
            }
            return result;
        }
        ,toJSON : function(nodo){
            if (nodo==undefined) nodo=this.ROOT_NODE;
            var arr = Ext.fly(nodo).query('.and, .or, .condicion');
            var res = [];
            var _self=this;
            Ext.each(arr, function(t){
                    if(Ext.fly(t).hasClass('condicion')){ res.push( _self.toJSONCondition(t) ); return; }
                    var type =  Ext.fly(t).hasClass('and') ? "and" : "or";

                    res.push( { type:type, rules : [].concat(_self.toJSON(t)) } );

            });

            if (res.length==1) return res[1];
            return res;
        }

        ,setCondition : function(condition){
            var selected = this.getSelected();
            if (!selected) {
            	Ext.MessageBox.alert("<s:message code="editorPaquetes.error" text="**Error" />", "<s:message code="editorPaquetes.seleccionarElemento" text="**Debe seleccionar un elemento" />");
            }
            canvas.arquetipoModificado();
            if (selected.hasClass("or") || selected.hasClass("and") ){
                this.setCondition_rulesBlock(condition);
            }else{
                this.setCondition_rule(condition);
            }
            this.initHandlers();
        }

        ,setCondition_rulesBlock : function(condition){
            var selected = this.getSelected();
            selected.dom.removeAttribute("title");
            var tit = selected.first();
            if (tit.hasClass('titulo_paquete')) tit.remove();
            if ( condition.title ){
                selected.dom.setAttribute("title", condition.title);
                selected.insertFirst({tag:'a',html:condition.title, href : '#', cls : 'titulo_paquete', title:condition.title}); 
            }
        }

        ,setCondition_rule : function(condition){
            var selected = this.getSelected();
            Ext.each(this.fields, function(f){
                selected.dom.removeAttribute(f);
                if (condition[f]!=undefined){
                    var value = typeof condition[f] !== "string" ? JSON.stringify(condition[f]) : condition[f];
                    selected.dom.setAttribute(f,value);
                }

            },this);
            var txt =   condition.title || "<s:message code="editorPaquetes.textoInicialRegla" text="**{editar}" />";
            selected.update( txt );
            if (condition.type && condition.type.indexOf('link')>=0){
            	selected.addClass('link');
            }else{
            	selected.removeClass('link');
            }
        }

        /* template method for adding new content */
        ,addElement : function(Fn){
            var selected =  this.getSelected();
            if (selected){
            	canvas.arquetipoModificado();
                Fn.call(this,selected);
                //optimizar aqui. Esto está asignando los eventos a más elementos de los necesarios. En principio aqui deberiamos
                //anyadir tan solo al elemento creado y al padre si se ha creado.
                this.initHandlers(selected.parent().parent());
            }
        }

        
        
        
        ,addAnd : function(nodo){
            if (!nodo.parent().hasClass('and')){
                nodo.wrap(this.snipplets.and);
                var name=canvas.getBlockName();
                nodo.parent().insertFirst({tag:'a',html:name, href : '#', cls : 'titulo_paquete'});
                nodo.parent().dom.setAttribute("title", name);
            }
            //nodo.append(this.snipplets.y);
            nodo.parent().insertHtml("beforeEnd", this.snipplets.y);
            this.setSelected(nodo.parent().last());
        }

        ,addOr : function(nodo){
            if (!nodo.parent().hasClass('or')){
            	var name=canvas.getBlockName();
                nodo.wrap(this.snipplets.or);
                nodo.parent().insertFirst({tag:'a',html:name, href : '#', cls : 'titulo_paquete'});
                nodo.parent().dom.setAttribute("title", name);
            }
            nodo.parent().insertHtml("beforeEnd", this.snipplets.o);
            this.setSelected(nodo.parent().last());
        }
        
        ,getRoot : function(){
        	return Ext.select('#esquema').item(0);
        }

		,isRoot : function(nodo){
			return nodo.dom.id=="esquema";
		}
		

        ,removeElement : function(nodo){
            if (!nodo) return;
			canvas.arquetipoModificado();
            var parent = nodo.parent();
            var propio=0;
            if (nodo.hasClass('condicion')) propio=1;
            if (Ext.query('.condicion').length==(nodo.query('.condicion').length+propio)) {
                alert("No se puede borrar la ultima condicion");
                return;
            }
            //si se queda el primero, se quita el siguiente
            if (parent.first('div').dom==nodo.dom){
                if (nodo.next()) nodo.next().remove();
            }

            if (nodo.prev('.orSeparator') !=null){ nodo.prev('.orSeparator').remove();}
            if (nodo.prev('.andSeparator') !=null){ nodo.prev('.andSeparator').remove();}
            nodo.remove();
            //para que no se queda un orSeparator colgado
            if (parent.first() && parent.first().hasClass('orSeparator')){
                parent.first().remove();
            }
            //comprobamos si es el ultimo que queda

            var p=parent;
            while (!this.isRoot(p) && p.query('> .condicion, > .or, > .and').length==1){
                p.replaceWith( p.first('div') ); //experimental
                p=p.parent();
            }

            //comprobamos que el padre es directamente un and o un or y no tiene varias capas
            if ( !this.isRoot(parent) && parent.select('> .and, >.or').getCount()==1){
                //console.debug("caso extra");
                //parent.replaceWith(parent.first());
            }
            /*
            */


        }

        ,ready : function(){
            Ext.get("esquema").on("click", function(){
                    this.removeSelected();
            },this);
        }

        ,importRuleXml : function(xml){
            var selected=this.getSelected();
            var node = document.createElement('div');
            Ext.get(node).update(this.Xml2Html(xml));
            selected.replaceWith(Ext.get(node).first());
            Ext.get(selected).select('*').each( function(it){ 
                if( !it.hasClass('and') && !it.hasClass('or') && !it.hasClass('link')) {
                    it.addClass(['condicion', 'box']);
                }    
				if (it.hasClass('link')){
					it.addClass('box');
				}
                
                if (it.parent().last().dom==it.dom) return; //los ultimos nodos no llevan separador detras

                if (it.parent().hasClass('and') ){
                        it.insertSibling("<div class='andSeparator'></div>", "after")
                }else{
                    if (it.parent().hasClass('or')){
                        it.insertSibling("<div class='orSeparator'></div>","after");
                    }
                }
            });
           
            
            this.initHandlers(this.getSelected());
        }
        ,importRule : function(html){
            var node = document.createElement('div');
            Ext.get(node).update(html);
            if (this.getSelected()){
                this.getSelected().replaceWith(Ext.get(node).first());
                this.initHandlers(this.getSelected());
            }
        }

        ,restart : function(){
            Ext.get("esquema").update('<div class="box condicion" type="compare1" ruleid="0" operator="equal" values=["1"] title="regla generica">regla generica</div> ');
            canvas.resetArquetipo();
            this.initHandlers();
            canvas.disableTopToolbar(false,true);
        }

        ,getXML :   function(){
            var node=document.createElement("root");
            node.innerHTML=  Ext.get("esquema").dom.innerHTML;
            Ext.get(node).select('.box').removeClass('box');
            Ext.get(node).select('.noborder').removeClass('noborder');
            Ext.get(node).select('a').remove();
            Ext.get(node).select('.andSeparator, .orSeparator').remove();
            Ext.get(node).select('.condicion').each( function(it){ it.dom.removeAttribute("class");});
            Ext.get(node).select('.link').each( function(it){
            	//Fix para el ie
            	it.dom.removeAttribute("operator"); 
            	it.dom.removeAttribute("class");
            	if (it.dom.attributes != undefined) {
	            	if (it.dom.attributes.getNamedItem("class") != null) it.dom.attributes.removeNamedItem("class");
	            	if (it.dom.attributes.getNamedItem("operator") != null) it.dom.attributes.removeNamedItem("operator");
	            	
	            	//Para que ponga las comillas en el title el ie		            	
	            	if (it.dom.attributes.getNamedItem("title") != null) {
		            	var typ=document.createAttribute("title");
						typ.nodeValue= it.dom.attributes.getNamedItem("title").value.trim()+" ";
						it.dom.attributes.setNamedItem(typ);
					}
					
            	}
            });
            Ext.get(node).select('*').each( function(it){ it.dom.removeAttribute("id");})
            var xml = node.innerHTML;
            xml = xml.replace(/<div /ig,"<rule ").replace(/<\/div/ig,"</rule").replace(/\sid="[^"]*"/ig,"").replace(/class=/ig,"type=")     ;
            var i=0;
            var tabs=[];
            for(var j=0;j < 15;j++) for(var k=0;k < j;k++) tabs[j] = (tabs[j]||"") + "\t";
            xml= xml.replace(/\<[^>]*>/g,function(it){ var open= it.indexOf("/")<0; if(open) i++; else i--; return "\n"+tabs[open? i:(i+1)]+it; })
            xml =   xml.replace(/&quot;/g, "\"");
            xml =   xml.replace(/\'\'/ig,"\"").replace(/\'/ig, "\"").replace(/\[\"/ig,"\[").replace(/\",\"/ig,",").replace(/\"\]/ig,"\]");            
            xml =   xml.replace(/\s?condition_selected/g, "");
            //Mas fix para el explorer
            xml =   xml.replace(/\s?operator /g, "").replace(/\s?class= /g, "").replace(/\s?class=\"\" /g, "");     
            xml =   xml.replace(/type=and/ig,"type=\"and\"").replace(/type=or/ig,"type=\"or\"").replace(/type=condicion/ig,"type=\"condicion\"");
            xml =   xml.replace(/undefined/ig,"");
            return xml;
        }

        ,Xml2Html : function(str){
            return str.replace(/<rule/ig,"<div").replace(/<\/rule/ig,"</div").replace(/type=/ig,"class=");
        }

        ,setXML : function(str){
            str = this.Xml2Html(str);
            Ext.get("esquema").dom.innerHTML=str;

            //ahora agregamos los divs andSeparator y orSeparator, y las clases condicion y box
            Ext.get("esquema").select('*').each( function(it){ 
            	if( (it.hasClass('and') || it.hasClass('or') ) && it.dom.title) {
            		it.insertFirst({tag:'a',html:this.dom.title, href : '#', cls : 'titulo_paquete', title:this.dom.title});
            	}
                if( !it.hasClass('and') && !it.hasClass('or') && !it.hasClass('link')) {
                    it.addClass(['condicion', 'box']);
                }    
				if (it.hasClass('link')){
					it.addClass('box');
					it.dom.setAttribute("type", "link");
				}
                
	            
                if (it.parent().last().dom==it.dom) return; //los ultimos nodos no llevan separador detras

                if (it.parent().hasClass('and') ){
                        it.insertSibling("<div class='andSeparator'></div>", "after")
                }else{
                    if (it.parent().hasClass('or')){
                        it.insertSibling("<div class='orSeparator'></div>","after");
                    }
                }
            });
            //Ext.get("esquema").first().addClass("noborder");
            this.initHandlers();
        }

        /*xml-------------*/
        ,getXML2 : function(node){

            var parser = function(node){

                var convert = function(node, dest){
                    var newnode = document.createElement(dest);
                    for(var i=0;i<node.attributes.length;i++){
                        newnode.setAttribute(node.attributes[i].name,node.attributes[i].value);
                    }

                    return newnode;
                }

                var replace = function(node, classOrig, tagDest){
                    var result=document.createElement("x");
                    result.innerHTML=Ext.get(node).dom.innerHTML;

                    var count=100;
                    while(Ext.get(result).query('.'+classOrig).length>0){
                        if (!count--){ return "excedido"}
                        var orig=Ext.get(result).select('.'+classOrig).first();
                        if (orig==null) {count--;continue;}
                        var newnode =   convert(orig.dom,tagDest);

                        Ext.get(newnode).removeClass(classOrig);
                        Ext.get(newnode).innerHTML=orig.dom.innerHTML;
                        //Ext.get(result).query('.box').first().dom.innerHTML=newnode.innerHTML;
                        orig.replaceWith(newnode);
                    }
                    return result;
                }

                node = replace(node,'and','and');
                node = replace(node,'or','or');
                node = replace(node,'box','rule');
                return node;
            }



            var nodo = document.createElement("span");
            nodo.innerHTML=Ext.get(node).dom.innerHTML;

            Ext.get(nodo).select('.andSeparator,.orSeparator').remove()
            //Ext.get(nodo).select('.box').removeClass('box');
                return parser(nodo);
        }
        });

Ext.reg('canvaspanel',Canvas);
