﻿﻿﻿﻿﻿﻿﻿﻿﻿<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>

<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>

<fwk:page>

    var maxWidth = 570;
    var bordersWidth = 40
	var totalUserRows = 0
	
	var labelStyle='font-weight:bolder;width:40';
	var labelStyleMail='font-weight:bolder;width:25;';
	var idUg = '${id}';
	var codUg = '${codUg}';
	var tamanyoMaximoAdjustos='${tamanyoMaximoAdjustos}';
	
	<%--Restricción de poner una fecha como mínimo con 3 días de tiempo a partir de hoy --%>
	var plazoMinimoAutotarea = '${plazoMinimoAutotarea}';
	var hoy = new Date();	
	var minDate = hoy.add(Date.MILLI,plazoMinimoAutotarea);
	
	
	var usuariosStore = page.getStore({
        //flow:'recoveryprevisiones/getListadoExpedientesPrevisionData'
        remoteSort:false
        ,data: {data:[{id:1, nombre: 'joan', incoporar:0, fecha:'', email:0}]}
        //,limit:25
        ,reader : new Ext.data.JsonReader({
            root:'data'
            //,totalProperty: 'total'
            ,fields:[
             {name: 'id'}
             ,{name: 'username'}
             ,{name: 'nombre'}
             ,{name:'tieneEmail'}
             ,{name: 'incorporar'}
             ,{name: 'fecha'}
             ,{name: 'email'}
         ]
        })
    });
    
    var activarEmail = false;    
    <sec:authorize ifAllGranted="ACTIVAR_EMAIL_ANOTACIONES">
    activarEmail = true;
    </sec:authorize>
	
    var rendererChechkbox = function(value, metaData, record, rowIndex, colIndex, store){ 
     
        
        if(parseInt(value) == 1){ 
            metaData.css='icon_checkbox_on';
        }
        else{
            metaData.css='icon_checkbox_off';
        }
        return '';
    };
    var rendererChechkboxMail = function(value, metaData, record, rowIndex, colIndex, store){ 
       
        var tieneEmail = record.get('tieneEmail');
         
        if(activarEmail && tieneEmail){          
	        if(parseInt(value) == 1){ 
	            metaData.css='icon_checkbox_on';
	        }
	        else{
	            metaData.css='icon_checkbox_off';
	        }
	    }else
	    	metaData.css='';
        return '';
    };
    
    var rendererFecha = function(value, metaData, record, rowIndex, colIndex, store){ 
        if (value) {
            return value.format('d/m/Y');
        } else {
            return '';
        }
        return '';
    };
    
    var cssReadOnly = 'background-color: #EAEAEA;';
    
    var fechaGrid = new Ext.ux.form.XDateField({
        name : 'fechaTodos'
        ,fieldLabel : '<s:message code="asunto.tabaceptacion.a" text="**Fecha todas"/>'
        ,allowBlank : true
        ,style:'margin:0px'
        ,labelStyle:labelStyle
        ,minValue : minDate
        ,width:125
        ,disabled:true
    });
	    
    var usuariosCm = new Ext.grid.ColumnModel({
        columns:[
             {header: '<s:message code="plugin.agendaMultifuncion.nuevaAnotacion.gridUsuarios.id" text="**Id" />', width: 10,  hidden:true,dataIndex: 'id',sortable:true, css:cssReadOnly}
             ,{header: '<s:message code="plugin.agendaMultifuncion.nuevaAnotacion.gridUsuarios.userName" text="**UserName" />', width: 25,  dataIndex: 'username',sortable:true, css:cssReadOnly}
             ,{header: '<s:message code="plugin.agendaMultifuncion.nuevaAnotacion.gridUsuarios.nombre" text="**Nombre" />', width: 70,  dataIndex: 'nombre',sortable:true, css:cssReadOnly}
        //     ,{header: '<s:message code="plugin.agendaMultifuncion.nuevaAnotacion.gridUsuarios.perfil" text="**perfil" />', width: 50,  dataIndex: 'perfil',sortable:true}
             ,{header: '<s:message code="plugin.agendaMultifuncion.nuevaAnotacion.gridUsuarios.incorporar" text="**incorporar" />', width: 17,  dataIndex: 'incorporar',sortable:true,renderer:rendererChechkbox}
             ,{header: '<s:message code="plugin.agendaMultifuncion.nuevaAnotacion.gridUsuarios.fecha" text="**fecha" />', width: 20,  dataIndex: 'fecha',sortable:true, editor: fechaGrid, renderer:rendererFecha}
             <sec:authorize ifAllGranted="ACTIVAR_EMAIL_ANOTACIONES">
            ,{header: '<s:message code="plugin.agendaMultifuncion.nuevaAnotacion.gridUsuarios.email" text="**email" />', width: 10,  dataIndex: 'email',sortable:true,renderer:rendererChechkboxMail}
            </sec:authorize>
        //  ,{header: '<s:message code="plugin.agendaMultifuncion.nuevaAnotacion.gridUsuarios.isOficina" text="**isOficina" />', width: 10,  dataIndex: 'oficina',sortable:false,hidden:false}
    ]});
    
    //Template para el combo de usuarios
    var usuarioTemplate = new Ext.XTemplate(
        '<tpl for="."><div class="search-item">',
            '<p>{nombre}</p>',
            '<p align="right"><i>{username}</i></p>',
        '</div></tpl>'
    );
    
    //Store del combo de usuarios
    var usuariosComboStore = page.getStore({
        flow:'recoveryagendamultifuncionanotacion/getUsuariosInstant'
        ,remoteSort:false
        ,autoLoad: false
        ,reader : new Ext.data.JsonReader({
            root:'data'
            ,fields:['nombre','username','tieneEmail']
        })
    });    
    
    //Combo de usuarios
    var comboUsuarios = new Ext.form.ComboBox({
        name: 'filtroUsuarios' 
        ,store:usuariosComboStore
        ,width:250
        ,fieldLabel: '<s:message code="plugin.listadoAgregadoExpedientesPrevision.filtros.comboGestor" text="**Gestor"/>'
        ,tpl: usuarioTemplate  
        ,forceSelection:true
        ,style:'padding:0px;margin:0px;'
        ,anchor: '100%'
        ,allowBlank:true
        ,enableKeyEvents: true
        ,typeAhead: false
        ,hideTrigger:true     
        ,minChars: 3 
        ,hidden:true
        ,maxLength:256 
        ,itemSelector: 'div.search-item'
        ,loadingText: '<s:message code="app.buscando" text="**Buscando..."/>'
        ,onSelect: function(record) { 
            var store = gridUsuarios.getStore();
            var rec = store.getById(record.id);
            if (!rec) {
            	
                var data = {data:[{
                        id: record.id
                        ,nombre:record.data.nombre
                        ,username: record.data.username
                        ,incorporar:0
                        ,fecha:null
                        ,email:0
                        ,tieneEmail :record.data.tieneEmail
                        
                }]
                };
                
                store.loadData(data, true);
                comboUsuarios.collapse();
                comboUsuarios.hide();
                gridUsuarios.getView().focusRow(totalUserRows);
                totalUserRows++;
            }
         }
    });
        
    
    var botonAnadirUsuario = new Ext.Button({
        text:'<s:message code="plugin.agendaMultifuncion.nuevaAnotacion.gridUsuarios.botonAnadirUsuario" text="**Anadir"/>'
        ,iconCls:'icon_mas'
        ,handler: function() {
            comboUsuarios.show();
            comboUsuarios.focus();
            
        }
    })
    
    var gridUsuarios = app.crearEditorGrid( 
            usuariosStore,usuariosCm,{
        title:'<s:message code="plugin.agendaMultifuncion.nuevaAnotacion.gridUsuarios.title" text="**Usuarios relacionados"/>'
        ,height : 120
        //,anchor:'100%' 
        ,style : 'margin-bottom:10px;padding-right:10px'
        ,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
        ,viewConfig: {forceFit: true}
        ,parentWidth:maxWidth
        //,autoWidth:true
        ,autoheight:true
        ,loadMask: {msg: "Cargando...", msgCls: "x-mask-loading"}
        //,tbar : [botonAnadirUsuario]
        ,bbar : [botonAnadirUsuario, comboUsuarios]
        ,clicksToEdit: 1
        
    });
    
    var cambiarTodasFechas = function(newDate) {
        var usuarioRecordList = usuariosStore.getRange();
        
        for (var i = 0; i < usuarioRecordList.length; i++) {
            if (usuarioRecordList[i].get('incorporar') == 1) {
                usuarioRecordList[i].set('fecha', newDate);
            }
        }
        
    };
    
    var permiteAdjuntar=0;
    
    gridUsuarios.on('cellclick', function(grid, rowIndex, columnIndex, e){
        var cm = gridUsuarios.getColumnModel();
        if (cm) {
            var columnName = cm.getColumnAt(columnIndex).dataIndex;
            
            if (columnName == 'fecha') {
           		var rec = gridUsuarios.getStore().getAt(rowIndex);
           		var value = parseInt(rec.get('incorporar'));
                if(rec){
	            	var fechaEditor = cm.getCellEditor(cm.findColumnIndex('fecha'), rowIndex).field;
	            	if (value == 1)  {
		                if(app.usuarioLogado.id == rec.data.id){
			            	fechaEditor.setMinValue('');
			            }else{
			            	fechaEditor.setMinValue(minDate);
			            }
			        }
	            }
            }
            if (columnName == 'incorporar') {
 
                var rec = gridUsuarios.getStore().getAt(rowIndex);
                if(rec){
                    var fechaEditor = cm.getCellEditor(cm.findColumnIndex('fecha'), rowIndex).field;
                    
                    var value = parseInt(rec.get('incorporar'));
                    if (value == 1)  {
                        value = 0;
                        rec.set('fecha', '');
                        fechaEditor.disable();
                        // FASE-1441 : No es posible desmarcar la casilla de incorporar y dejar marcada la de email 
                        rec.set('email', value);
                    }
                    else {
                        fechaEditor.enable();
                        value = 1;
                    }
                    
                    rec.set('incorporar', value);

                }
            }
            
            if (columnName == 'email') {

                var rec = grid.getStore().getAt(rowIndex);
                var tieneEmail = rec.get('tieneEmail');
                if(tieneEmail){
	                if(rec){
	                    var value = parseInt(rec.get('email'));
	                   
	                    if (value == 1) {
	                    	value = 0;
	                    	permiteAdjuntar=permiteAdjuntar-1;
	                    }
	                    else {
	                    	value = 1;
	                    	permiteAdjuntar=permiteAdjuntar+1;
	                    	// FASE-1441 : No es posible marcar la casilla de email sin marcar la de incorporar. 
	                    	// Al marcar la casilla de incorporar habilitamos el campo de fecha. 
	                    	rec.set('incorporar', value);
	                    	var fechaEditor = cm.getCellEditor(cm.findColumnIndex('fecha'), rowIndex).field;
	                    	fechaEditor.enable();
	                    }
	                    if((mailPara.validate() && mailPara.getValue()!=null && mailPara.getValue()!='') ||(permiteAdjuntar>0)){
	                    	panelAdjuntos.setDisabled(false);
	                    	etiquetaErrorAdjuntos.hide();
	                    }else{
	                    	var adjuntosList=incluirAdjuntos();
	                    	if (adjuntosList != null && adjuntosList != ''){
	                    		etiquetaErrorAdjuntos.show();
	                    	}else{
	                    		etiquetaErrorAdjuntos.hide();
	                    	}
	                    	panelAdjuntos.setDisabled(true);
							panelAdjuntos.collapse(true);
	                    }	
	                    rec.set('email', value);
	                }
                }else{
                	value=0;
                	rec.set('email', value);
                }
            }
        }
    });
    
    var widthCamposMail = 400;
    
    var emailPattern = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+(\,\s*([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4}))*$/;
    
    var mailValidator = function(value) {
        if ((value!=null && value != '' && !emailPattern.test(value))) {
            return '<s:message code="plugin.agendaMultifuncion.nuevaAnotacion.mailError" text="**Formato incorrecto, debe introducir direcciones de email separadas por comas: aa@aa.com, bb@bb.com"/>'
        }
        return true
    };
    
     var mailValidatorPara = function(value) {
     	if (!(permiteAdjuntar>0)){
	        if ( !emailPattern.test(value)) {
	            return '<s:message code="plugin.agendaMultifuncion.nuevaAnotacion.mailError" text="**Formato incorrecto, debe introducir direcciones de email separadas por comas: aa@aa.com, bb@bb.com"/>'
	        }
        }
        return true
    };
    
    var mailPara = new Ext.form.TextField({
        width : widthCamposMail
        ,fieldLabel: '<s:message code="plugin.agendaMultifuncion.nuevaAnotacion.mail.para" text="**para"/>'
        ,labelStyle:labelStyleMail
        ,validator: mailValidator

    });
    
    var mailCC = new Ext.form.TextField({
        width : widthCamposMail
        ,fieldLabel: '<s:message code="plugin.agendaMultifuncion.nuevaAnotacion.mail.cc" text="**cc"/>'
        ,labelStyle:labelStyleMail
        ,validator: mailValidator


    });
    
    var mailAsunto = new Ext.form.TextField({
        width : widthCamposMail
        ,fieldLabel: '<s:message code="plugin.agendaMultifuncion.nuevaAnotacion.mail.asunto" text="**Asunto"/>'
        ,labelStyle:labelStyleMail
        ,allowBlank : false
    });
    <%-- 
    btnAdjuntar = new Ext.Button({
	           text : '<s:message code="plugin.agendaMultifuncion.nuevaAnotacion.btnAdjuntar" text="**Adjuntar" />'
	           ,iconCls:'icon_editar_propuesta'
	           ,disabled:false
	           ,width:80
	           ,handler: function() {
	           		var w= app.openWindow({
                                         flow: 'recoveryagendamultifuncionanotacion/getAdjuntosEntidad'
                                         ,closable: true
                                         ,width : 700
                                         ,title : '<s:message code="plugin.arquetipos.busqueda.modificar" text="**Modificar" />'
                                         ,params: {id:idUg,codUg:codUg}
                        });
           	 		w.on(app.event.DONE, function(){
								w.close();
								//recargar() ;
								
					});
					w.on(app.event.CANCEL, function(){
								 w.close(); 
					});
				}	
	    });
    --%>
    var cuerpoEmail = new Ext.form.HtmlEditor({
        id:'cuerpoMail'
        ,hideLabel:true
        ,labelSeparator:''
        ,allowBlank : true
        ,width: 525
        ,height: 142
        ,value:''
        ,allowBlank : false
    });
    
    var fechaTodas = new Ext.ux.form.XDateField({
        name : 'fechaTodos'
        ,fieldLabel : '<s:message code="plugin.agendaMultifuncion.nuevaAnotacion.campoFechaTodas" text="**Fecha todas"/>'
        ,value : ''
        ,labelStyle:'font-weight:bolder;width:80px'
        ,minValue : minDate
        ,width:80
        ,required: false
    });
    
    fechaTodas.on('change', function( field, newValue, oldValue ) {
        if (newValue != '') {
            Ext.Msg.show({
                title:'<s:message code="plugin.agendaMultifuncion.nuevaAnotacion.cambiarTodasFechas.alert.title" text="**Atención!"/>'
                ,msg: '<s:message code="plugin.agendaMultifuncion.nuevaAnotacion.cambiarTodasFechas.alert.body" text="**Se van a cambiar...?"/>'
                ,buttons: Ext.Msg.YESNO
                ,icon: Ext.MessageBox.WARNING
                ,fn: function(result) {
                    if (result = 'yes') {
                        cambiarTodasFechas(newValue);
                    }
                }
             });
        }
    });
    
    var tipoAnotacionStore = page.getStore({
        flow:'recoveryagendamultifuncionanotacion/obtenerTiposAnotaciones'
        ,remoteSort:false
        ,autoLoad: true
        ,reader : new Ext.data.JsonReader({
            root:'diccionario'
            ,fields:['codigo','descripcion']
        })
    });
   <%--  
    var dictCombos = 
    {'diccionario':[
        {'codigo':'R','descripcion':'Recordatorio'} 
        ,{'codigo':'A','descripcion':'Alerta'} 
    ]};
    
        var tipo = app.creaCombo({
        data : dictCombos
        ,name : 'tipo'
        ,allowBlank : false
        ,fieldLabel : '<s:message code="plugin.agendaMultifuncion.nuevaAnotacion.campoTipo" text="**Tipo"/>'
        ,value : ''
        ,labelStyle:labelStyle
        ,width:125
    });
--%>

	var tipo = new Ext.form.ComboBox({
        name: 'tipo' 
        ,mode:'local'
        ,store:tipoAnotacionStore
        ,width:80
        ,fieldLabel: '<s:message code="plugin.agendaMultifuncion.nuevaAnotacion.campoTipo" text="**Tipo"/>'
        ,allowBlank:false
        ,triggerAction: 'all'
		,labelStyle:labelStyle
		,valueField: 'codigo'
    	,displayField: 'descripcion'
    	//,editable:false
    });


    
    var camposContainer = new Ext.Container({
    	layout:'form'
    	,id:'camposContainer'
    	,items :[tipo]
    	,height: 25
    	,width:200
	 });
	 
	 var camposContainer2 = new Ext.Container({
    	layout:'form'
    	,id:'camposContainer2'
    	,items :[fechaTodas]
    	,height: 25
    	,width:200
	 });   

    
   var columnas = new Ext.form.FieldSet({
	id:'columnas'
	,layout : 'table'
	,layoutConfig: {
        columns: 2
    }
	,border:false
	,width:maxWidth
	,height:170
	,style:'padding:0px'
	,defaults : {xtype : 'fieldset', autoHeight : false, border : false ,cellCls : 'vtop'}
	,items : [
	     camposContainer
	    ,
	     camposContainer2
	    ,
	     {
	     colspan:2, style:'padding-top:0px;padding-bottom:0px',items:[cuerpoEmail]
	   }]
 	}); 
 	
 	Ext.grid.CheckColumn = function(config){
			    Ext.apply(this, config);
			    if(!this.id){
			        this.id = Ext.id();
			    }
			    this.renderer = this.renderer.createDelegate(this);
			};

			Ext.grid.CheckColumn.prototype ={
			    init : function(grid){
			        this.grid = grid;
			        this.grid.on('render', function(){
			            var view = this.grid.getView();
			            view.mainBody.on('mousedown', this.onMouseDown, this);
			        }, this);
			    },

			    onMouseDown : function(e, t){
			        if(t.className && t.className.indexOf('x-grid3-cc-'+this.id) != -1){
			            e.stopEvent();
			            var index = this.grid.getView().findRowIndex(t);
			            var record = this.grid.store.getAt(index);
			            record.set(this.dataIndex, !record.data[this.dataIndex]);
			        }
			    },
			
			    renderer : function(v, p, record){
			        p.css += ' x-grid3-check-col-td'; 
			        return '<div class="x-grid3-check-col'+(v?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
			    }
			};
 	
 	var adjuntar_edit = new Ext.grid.CheckColumn({ 
		            header : '<s:message code="plugin.agendaMultifuncion.nuevaAnotacion.gridUsuarios.adjuntar" text="**Adjuntar" />'
		            ,dataIndex : 'adjuntar', width: 40});
	var adjuntarPersona_edit = new Ext.grid.CheckColumn({ 
		            header : '<s:message code="plugin.agendaMultifuncion.nuevaAnotacion.gridUsuarios.adjuntar" text="**Adjuntar" />'
		            ,dataIndex : 'adjuntar', width: 40});
		            
	var adjuntarExpediente_edit = new Ext.grid.CheckColumn({ 
		            header : '<s:message code="plugin.agendaMultifuncion.nuevaAnotacion.gridUsuarios.adjuntar" text="**Adjuntar" />'
		            ,dataIndex : 'adjuntar', width: 40});
	
	var adjuntarContrato_edit = new Ext.grid.CheckColumn({ 
		            header : '<s:message code="plugin.agendaMultifuncion.nuevaAnotacion.gridUsuarios.adjuntar" text="**Adjuntar" />'
		            ,dataIndex : 'adjuntar', width: 40});
		            
	var adjuntarCliente_edit = new Ext.grid.CheckColumn({ 
		            header : '<s:message code="plugin.agendaMultifuncion.nuevaAnotacion.gridUsuarios.adjuntar" text="**Adjuntar" />'
		            ,dataIndex : 'adjuntar', width: 40});
		            
	var adjuntarAdjuntosExpediente_edit = new Ext.grid.CheckColumn({ 
		            header : '<s:message code="plugin.agendaMultifuncion.nuevaAnotacion.gridUsuarios.adjuntar" text="**Adjuntar" />'
		            ,dataIndex : 'adjuntar', width: 40});		            		            
		                  	            			            
 	
 		var Adjunto = Ext.data.Record.create([
		{name : 'id'}
		,{name : 'nombre'}
		,{name : 'tipo'}
		,{name : 'length'}
		,{name : 'adjuntar'}
		,{name : 'contentType'}
		,{name : 'idAdjunto'}
	]);

	var AdjuntosPersonas = Ext.data.Record.create([
		{name : 'id'}
		,{name : 'idEntidad'}
		,{name : 'descripcionEntidad'}
		,{name : 'nombre'}
		,{name : 'tipo'}
		,{name : 'length'}
		,{name : 'contentType'}
		,{name : 'idAdjunto'}
	]);

	var AdjuntosExpedientes = Ext.data.Record.create([
		{name : 'id'}
		,{name : 'idEntidad'}
		,{name : 'descripcionEntidad'}
		,{name : 'nombre'}
		,{name : 'tipo'}
		,{name : 'length'}
		,{name : 'contentType'}
		,{name : 'idAdjunto'}
	]);

	var AdjuntosContratos = Ext.data.Record.create([
		{name : 'id'}
		,{name : 'idEntidad'}
		,{name : 'descripcionEntidad'}
		,{name : 'nombre'}
		,{name : 'tipo'}
		,{name : 'length'}
		,{name : 'contentType'}
		,{name : 'idAdjunto'}
	]);

	
	
	var store = page.getStore({
		flow : 'recoveryagendaadjuntoscorreo/consultaAdjuntos'
		,reader : new Ext.data.JsonReader({
			root : 'adjuntos'
			,totalProperty : 'total'
		},Adjunto)
	});

	var storePersonas = page.getStore({
		flow : 'recoveryagendaadjuntoscorreo/consultaAdjuntosPersona'
		,reader : new Ext.data.JsonReader({
			root : 'adjuntos'
			,totalProperty : 'total'
		},AdjuntosPersonas)
	});

	var storeExpedientes = page.getStore({
		flow : 'recoveryagendaadjuntoscorreo/consultaAdjuntosExpedientes'
		,reader : new Ext.data.JsonReader({
			root : 'adjuntos'
			,totalProperty : 'total'
		},AdjuntosExpedientes)
	});

	var storeContratos = page.getStore({
		flow : 'recoveryagendaadjuntoscorreo/consultaAdjuntosContratos'
		,reader : new Ext.data.JsonReader({
			root : 'adjuntos'
			,totalProperty : 'total'
		},AdjuntosContratos)
	});
	
	var storeAdjuntosCliente = page.getStore({
		flow : 'recoveryagendaadjuntoscorreo/consultaAdjuntosCliente'
		,reader : new Ext.data.JsonReader({
			root : 'adjuntos'
			,totalProperty : 'total'
		},Adjunto)
	});
	
	var storeAdjuntosExpediente = page.getStore({
		flow : 'recoveryagendaadjuntoscorreo/consultaAdjuntosDelExpediente'
		,reader : new Ext.data.JsonReader({
			root : 'adjuntos'
			,totalProperty : 'total'
		},Adjunto)
	});

	var recargarAdjuntos=function (){
	};
	
	<c:if test="${codUg=='3'}">
		var recargarAdjuntos = function (){
		store.webflow({id:idUg});
		storePersonas.webflow({id:idUg});
		storeExpedientes.webflow({id:idUg});
		storeContratos.webflow({id:idUg});
	};
	</c:if>
	<c:if test="${codUg=='1'}">
		var recargarAdjuntos = function (){
		storeAdjuntosCliente.webflow({id:idUg});
	};
	</c:if>
	<c:if test="${codUg=='2'}">
		var recargarAdjuntos = function (){
		storeAdjuntosExpediente.webflow({id:idUg});
	};
	</c:if>
	

	recargarAdjuntos();
	
	var cm = new Ext.grid.ColumnModel([
		{header : '<s:message code="asuntos.adjuntos.nombre" text="**Nombre" />', dataIndex : 'nombre',css:cssReadOnly}
		,{header : '<s:message code="asuntos.adjuntos.tamanyo" text="**Tama&ntilde;o" />', dataIndex : 'length', renderer : app.format.fileSizeRenderer, align:'right',css:cssReadOnly}
		,{header : '<s:message code="asuntos.adjuntos.tipo" text="**Tipo" />', dataIndex : 'contentType',css:cssReadOnly}
		,{header : '<s:message code="asuntos.adjuntos.idAdjunto" text="**idAdjunto" />', dataIndex : 'idAdjunto',hidden:true}
		,adjuntar_edit
	]);

	var cmPersonas = new Ext.grid.ColumnModel([
		{header : '<s:message code="asuntos.adjuntos.cliente" text="**Cliente" />', dataIndex : 'descripcionEntidad', id:'colCodigoEntidad',css:cssReadOnly}
		,{header : '<s:message code="asuntos.adjuntos.nombre" text="**Nombre" />', dataIndex : 'nombre',css:cssReadOnly}
		,{header : '<s:message code="asuntos.adjuntos.tamanyo" text="**Tama&ntilde;o" />', dataIndex : 'length', renderer : app.format.fileSizeRenderer, align:'right',css:cssReadOnly}
		,{header : '<s:message code="asuntos.adjuntos.tipo" text="**Tipo" />', dataIndex : 'contentType'}
		,{header : '<s:message code="asuntos.adjuntos.idAdjunto" text="**idAdjunto" />', dataIndex : 'idAdjunto',hidden:true}
		,adjuntarPersona_edit
	]);

	var cmExpedientes = new Ext.grid.ColumnModel([
		{header : '<s:message code="asuntos.adjuntos.expediente" text="**Expediente" />', dataIndex : 'descripcionEntidad', id:'colCodigoEntidad',css:cssReadOnly}
		,{header : '<s:message code="asuntos.adjuntos.nombre" text="**Nombre" />', dataIndex : 'nombre',css:cssReadOnly}
		,{header : '<s:message code="asuntos.adjuntos.tamanyo" text="**Tama&ntilde;o" />', dataIndex : 'length', renderer : app.format.fileSizeRenderer, align:'right',css:cssReadOnly}
		,{header : '<s:message code="asuntos.adjuntos.tipo" text="**Tipo" />', dataIndex : 'contentType'}
		,{header : '<s:message code="asuntos.adjuntos.idAdjunto" text="**idAdjunto" />', dataIndex : 'idAdjunto',hidden:true}
		,adjuntarExpediente_edit
	]);

	var cmContratos = new Ext.grid.ColumnModel([
		{header : '<s:message code="asuntos.adjuntos.contrato" text="**Contrato" />', dataIndex : 'descripcionEntidad', id:'colCodigoEntidad',css:cssReadOnly}
		,{header : '<s:message code="asuntos.adjuntos.nombre" text="**Nombre" />', dataIndex : 'nombre',css:cssReadOnly}
		,{header : '<s:message code="asuntos.adjuntos.tamanyo" text="**Tama&ntilde;o" />', dataIndex : 'length', renderer : app.format.fileSizeRenderer, align:'right',css:cssReadOnly}
		,{header : '<s:message code="asuntos.adjuntos.tipo" text="**Tipo" />', dataIndex : 'contentType'}
		,{header : '<s:message code="asuntos.adjuntos.idAdjunto" text="**idAdjunto" />', dataIndex : 'idAdjunto',hidden:true}
		,adjuntarContrato_edit
	]);
	
	var cmAdjuntosCliente = new Ext.grid.ColumnModel([
		{header : '<s:message code="asuntos.adjuntos.nombre" text="**Nombre" />', dataIndex : 'nombre',css:cssReadOnly}
		,{header : '<s:message code="asuntos.adjuntos.tamanyo" text="**Tama&ntilde;o" />', dataIndex : 'length', renderer : app.format.fileSizeRenderer, align:'right',css:cssReadOnly}
		,{header : '<s:message code="asuntos.adjuntos.tipo" text="**Tipo" />', dataIndex : 'contentType',css:cssReadOnly}
		,{header : '<s:message code="asuntos.adjuntos.idAdjunto" text="**idAdjunto" />', dataIndex : 'idAdjunto',hidden:true}
		,adjuntarCliente_edit
	]);
	
	var cmAdjuntosExpediente = new Ext.grid.ColumnModel([
		{header : '<s:message code="asuntos.adjuntos.nombre" text="**Nombre" />', dataIndex : 'nombre',css:cssReadOnly}
		,{header : '<s:message code="asuntos.adjuntos.tamanyo" text="**Tama&ntilde;o" />', dataIndex : 'length', renderer : app.format.fileSizeRenderer, align:'right',css:cssReadOnly}
		,{header : '<s:message code="asuntos.adjuntos.tipo" text="**Tipo" />', dataIndex : 'contentType',css:cssReadOnly}
		,{header : '<s:message code="asuntos.adjuntos.idAdjunto" text="**idAdjunto" />', dataIndex : 'idAdjunto',hidden:true}
		,adjuntarAdjuntosExpediente_edit
	]);
	
	
	
	var gridHeight = 100;
	
	var grid = app.crearEditorGrid( 
            store,cm,{
        height : 120
        //,anchor:'100%' 
        ,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
        ,viewConfig: {forceFit: true}
        ,parentWidth:maxWidth - bordersWidth
        ,width:maxWidth - bordersWidth
        ,plugins:adjuntar_edit
   		,collapsible:true
   		,collapsed:false
        ,autoheight:true
        ,style : 'padding:0px; margin:0px'
        ,loadMask: {msg: "Cargando...", msgCls: "x-mask-loading"}
        ,clicksToEdit: 1
        ,border: false
    });
    
    grid.on('afterlayout', function (comp) {
                if(comp.header)
                    comp.header.setStyle('display', 'none');                
            });
    
    
    var adjuntosAsuntoFieldSet = new Ext.form.FieldSet({
        title:'<s:message code="asuntos.adjuntos.grid" text="**Adjuntos"/>'
        ,collapsible:true
        ,collapsed:true
        ,height: 200
        ,style : 'padding:0px;'
        ,parentWidth:maxWidth - bordersWidth
        ,width:maxWidth - bordersWidth
        ,items: [grid]
    });
	 	
	var gridPersonas = app.crearEditorGrid(storePersonas, cmPersonas, {
		height: gridHeight
		,parentWidth:maxWidth - bordersWidth
        ,width:maxWidth - bordersWidth
		,collapsible:false
        ,collapsed:false
		,plugins:adjuntarPersona_edit
		,style : 'padding:0px; margin:0px'
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
	});
	
	
	gridPersonas.on('afterlayout', function (comp) {
                if(comp.header)
                    comp.header.setStyle('display', 'none');                
            });
    
    
    var adjuntosPersonaFieldSet = new Ext.form.FieldSet({
        title : '<s:message code="asuntos.adjuntos.grid.personas" text="**Ficheros adjuntos Personas" />'
        ,collapsible:true
        ,collapsed:true
        ,autoHeight: true
        ,style : 'padding:0px;'
        ,parentWidth:maxWidth - bordersWidth
        ,width:maxWidth - bordersWidth
        ,items: [gridPersonas]
    });

	var gridExpedientes = app.crearEditorGrid(storeExpedientes, cmExpedientes, {
		height: gridHeight
		,parentWidth:maxWidth - bordersWidth
        ,width:maxWidth - bordersWidth
		,collapsible:false
		,collapsed:false
		,plugins:adjuntarExpediente_edit
		,style : 'padding:0px; margin:0px'
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
	});
	
	gridExpedientes.on('afterlayout', function (comp) {
                if(comp.header)
                    comp.header.setStyle('display', 'none');                
            });
    
    
    var adjuntosExpedienteFieldSet = new Ext.form.FieldSet({
        title : '<s:message code="asuntos.adjuntos.grid.expediente" text="**Ficheros adjuntos del Expediente" />'
        ,collapsible:true
        ,collapsed:true
        ,autoHeight: true
        ,style : 'padding:0px;'
        ,parentWidth:maxWidth - bordersWidth
        ,width:maxWidth - bordersWidth
        ,items: [gridExpedientes]
    });
	
	
	var gridContratos = app.crearEditorGrid(storeContratos, cmContratos, {
		height: gridHeight
		,parentWidth:maxWidth - bordersWidth
        ,width:maxWidth - bordersWidth
		,collapsible:false
        ,collapsed:false
		,style : 'padding:0px; margin:0px: border:0px'
		,plugins:adjuntarContrato_edit
		,parentWidth:maxWidth
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
	});
	
	gridContratos.on('afterlayout', function (comp) {
                if(comp.header)
                    comp.header.setStyle('display', 'none');                
            });
    
    
    var adjuntosContratoFieldSet = new Ext.form.FieldSet({
        title : '<s:message code="asuntos.adjuntos.grid.contratos" text="**Ficheros adjuntos Contratos" />'
        ,collapsible:true
        ,collapsed:true
        ,autoHeight: true
        ,style : 'padding:0px;'
        ,parentWidth:maxWidth - bordersWidth
        ,width:maxWidth - bordersWidth
        ,items: [gridContratos]
    });
	

	var gridAdjuntosCliente = app.crearEditorGrid( 
            storeAdjuntosCliente,cmAdjuntosCliente,{
        height : 120
        //,anchor:'100%' 
        ,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
        ,viewConfig: {forceFit: true}
        ,parentWidth:maxWidth - bordersWidth
        ,width:maxWidth - bordersWidth
        ,plugins:adjuntarCliente_edit
   		,collapsible:false
        ,collapsed:false
        ,autoheight:true
        ,style : 'padding:0px; margin:0px'
        ,loadMask: {msg: "Cargando...", msgCls: "x-mask-loading"}
        ,clicksToEdit: 1
    });
    
    
    gridAdjuntosCliente.on('afterlayout', function (comp) {
                if(comp.header)
                    comp.header.setStyle('display', 'none');                
            });
    
    
    var adjuntosClienteFieldSet = new Ext.form.FieldSet({
        title:'<s:message code="asuntos.adjuntos.grid" text="**Adjuntos"/>'
        ,collapsible:true
        ,collapsed:true
        ,autoHeight: true
        ,style : 'padding:0px;'
        ,parentWidth:maxWidth - bordersWidth
        ,width:maxWidth - bordersWidth
        ,items: [gridAdjuntosCliente]
    });
    
    var gridAdjuntosExpediente = app.crearEditorGrid( 
            storeAdjuntosExpediente,cmAdjuntosExpediente,{
        height : 120
        //,anchor:'100%' 
        ,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
        ,viewConfig: {forceFit: true}
        ,parentWidth:maxWidth - bordersWidth
        ,width:maxWidth - bordersWidth
        ,plugins:adjuntarAdjuntosExpediente_edit
   		,collapsible:false
        ,collapsed:false
        ,autoheight:true
        ,style : 'padding:0px; margin:0px'
        ,loadMask: {msg: "Cargando...", msgCls: "x-mask-loading"}
        ,clicksToEdit: 1
    });
    
    
    gridAdjuntosExpediente.on('afterlayout', function (comp) {
                if(comp.header)
                    comp.header.setStyle('display', 'none');                
            });
    
    
    var adjuntosExpedienteFieldSet2 = new Ext.form.FieldSet({
        title:'<s:message code="asuntos.adjuntos.grid" text="**Adjuntos"/>'
        ,collapsible:true
        ,collapsed:true
        ,autoHeight: true
        ,style : 'padding:0px;'
        ,parentWidth:maxWidth - bordersWidth
        ,width:maxWidth - bordersWidth
        ,items: [gridAdjuntosExpediente]
    });
    
    var etiquetaErrorAdjuntos = new Ext.form.Label({cls:'warning_message',
    	html:'<s:message code="plugin.agendaMultifuncion.nuevaAnotacion.sinDireccionConAdjuntos" text="**Los ficheros adjuntos seleccionados no se enviarán si no introduce una dirección de correo válida." />',
    	hidden:true});
    
	var panelAdjuntos = new Ext.form.FieldSet({
		title: '<s:message code="asuntos.adjuntos.tabTitle" text="**Adjuntos" />'
		,collapsible:true
		,collapsed:true
		<%--
		,parentWidth:maxWidth
		,parentWidth:maxWidth
		 --%>
		, style: '{margin-right:0px}'
		,autoWidth:true
		,autoHeight: true
		,disabled:true
		,items : [
			]		
	});
	<c:if test="${codUg=='3'}">
	var panelAdjuntos = new Ext.form.FieldSet({
		title: '<s:message code="asuntos.adjuntos.tabTitle" text="**Adjuntos" />'
		,collapsible:true
		,collapsed:true
        ,width:maxWidth - 10
		,autoHeight: true
		,disabled:true
		,items : [
				{items:[adjuntosAsuntoFieldSet],border:false,style:'margin-top: 2px; margin-left:2px'}
				,{items:[adjuntosExpedienteFieldSet],border:false,style:'margin-top: 2px; margin-left:2px'}
				,{items:[adjuntosPersonaFieldSet],border:false,style:'margin-top: 2px; margin-left:2px'}
				,{items:[adjuntosContratoFieldSet],border:false,style:'margin-top: 2px; margin-left:2px'}
			]		
	});
	</c:if>
	
	<c:if test="${codUg=='1'}">
	var panelAdjuntos = new Ext.form.FieldSet({
		title: '<s:message code="asuntos.adjuntos.tabTitle" text="**Adjuntos" />'
		,collapsible:true
		,collapsed:true
		,parentWidth:maxWidth
        ,width:maxWidth
		,autoHeight: true
		,disabled:true
		,items : [
				{items:[adjuntosClienteFieldSet],border:false,style:'margin-top: 2px; margin-left:2px'}
			]		
	});
	</c:if>
	
	<c:if test="${codUg=='2'}">
	var panelAdjuntos = new Ext.form.FieldSet({
		title: '<s:message code="asuntos.adjuntos.tabTitle" text="**Adjuntos" />'
		,collapsible:true
		,collapsed:true
		,width:maxWidth
		,autoHeight: true
		,disabled:true
		,items : [
				{items:[adjuntosExpedienteFieldSet2],border:false,style:'margin-top: 2px; margin-left:2px'}
			]		
	});
	</c:if>	
	
	
	
	mailPara.on('blur', function(){
		if ((mailPara.validate() && mailPara.getValue()!=null && mailPara.getValue()!='') ||(permiteAdjuntar>0)){
			etiquetaErrorAdjuntos.hide();
			panelAdjuntos.setDisabled(false);
		}else{
           	var adjuntosList=incluirAdjuntos();
           	if (adjuntosList != null && adjuntosList != ''){
           		etiquetaErrorAdjuntos.show();
           	}else{
           		etiquetaErrorAdjuntos.hide();
           	}
			panelAdjuntos.setDisabled(true);
			panelAdjuntos.collapse(true);
		}
	});
	
	var cumpleTamMax=true;
	
	function incluirAdjuntos() {
		var store = grid.getStore();
		var listaAdjuntos = '';
		var datos;
		var tamAdjuntos=0;
		for (var i=0; i < store.data.length; i++) {
			datos = store.getAt(i);
			if(datos.get('adjuntar') == true) {
				if(listaAdjuntos!='') listaAdjuntos += ',';
	      		listaAdjuntos += datos.get('idAdjunto');
	      		listaAdjuntos += '#'+datos.get('nombre');
	      		listaAdjuntos += '#'+datos.get('contentType');
	      		tamAdjuntos += datos.get('length');
			}
		}
		var storePersonas = gridPersonas.getStore();
		var datosPersonas;
		for (var i=0; i < storePersonas.data.length; i++) {
			datosPersonas = storePersonas.getAt(i);
			if(datosPersonas.get('adjuntar') == true) {
				if(listaAdjuntos!='') listaAdjuntos += ',';
	      		listaAdjuntos += datosPersonas.get('idAdjunto');
	      		listaAdjuntos += '#'+datosPersonas.get('nombre');
	      		listaAdjuntos += '#'+datosPersonas.get('contentType');
	      		tamAdjuntos += datos.get('length');
			}
		}
		var storeExpedientes = gridExpedientes.getStore();
		var datosExpediente;
		for (var i=0; i < storeExpedientes.data.length; i++) {
			datosExpediente = storeExpedientes.getAt(i);
			if(datosExpediente.get('adjuntar') == true) {
				if(listaAdjuntos!='') listaAdjuntos += ',';
	      		listaAdjuntos += datosExpediente.get('idAdjunto');
	      		listaAdjuntos += '#'+datosExpediente.get('nombre');
	      		listaAdjuntos += '#'+datosExpediente.get('contentType');
	      		tamAdjuntos += datos.get('length');
			}
		}
		var storeContratos = gridContratos.getStore();
		var datosContratos;
		for (var i=0; i < storeContratos.data.length; i++) {
			datosContratos = storeContratos.getAt(i);
			if(datosContratos.get('adjuntar') == true) {
				if(listaAdjuntos!='') listaAdjuntos += ',';
	      		listaAdjuntos += datosContratos.get('idAdjunto');
	      		listaAdjuntos += '#'+datosContratos.get('nombre');
	      		listaAdjuntos += '#'+datosContratos.get('contentType');
	      		tamAdjuntos +=datos.get('length');
			}
		}
		var datosAdjuntosCliente;
		for (var i=0; i < storeAdjuntosCliente.data.length; i++) {
			datosAdjuntosCliente = storeAdjuntosCliente.getAt(i);
			if(datosAdjuntosCliente.get('adjuntar') == true) {
				if(listaAdjuntos!='') listaAdjuntos += ',';
	      		listaAdjuntos +=datosAdjuntosCliente.get('idAdjunto');
	      		listaAdjuntos += '#'+datosAdjuntosCliente.get('nombre');
	      		listaAdjuntos += '#'+datosAdjuntosCliente.get('contentType');
	      		tamAdjuntos +=datosAdjuntosCliente.get('length');
			}
		}
		var datosAdjuntosExpediente;
		for (var i=0; i < storeAdjuntosExpediente.data.length; i++) {
			datosAdjuntosExpediente = storeAdjuntosExpediente.getAt(i);
			if(datosAdjuntosExpediente.get('adjuntar') == true) {
				if(listaAdjuntos!='') listaAdjuntos += ',';
	      		listaAdjuntos +=datosAdjuntosExpediente.get('idAdjunto');
	      		listaAdjuntos += '#'+datosAdjuntosExpediente.get('nombre');
	      		listaAdjuntos += '#'+datosAdjuntosExpediente.get('contentType');
	      		tamAdjuntos +=datosAdjuntosExpediente.get('length');
			}
		}
		if ( tamAdjuntos> tamanyoMaximoAdjustos) {
			cumpleTamMax=false;
		} else {
			cumpleTamMax=true;
		}	
		return listaAdjuntos;
	}
    
    var botonCerrar = new Ext.Button({
        text:'<s:message code="plugin.agendaMultifuncion.nuevaAnotacion.botonCerrar" text="**Cerrar"/>'
        ,iconCls:'icon_cancel'
        ,handler: function() {
           page.fireEvent(app.event.CANCEL);
        }
    });
    
    var validar = function() {
        var result = true;
        
        result = result && mailAsunto.validate();
        result = result && mailPara.validate();
        result = result && mailCC.validate();
        result = result && tipo.validate();
        
        if (cuerpoEmail.getValue() == '') {
            result =false;
            Ext.Msg.alert(
                    '<s:message code="plugin.agendaMultifuncion.nuevaAnotacion.errorMailBody.title" text="**Atención!"/>'
                    ,'<s:message code="plugin.agendaMultifuncion.nuevaAnotacion.errorMailBody.body" text="**El cuerpo de la anotación es un campo obligatorio"/>'
            );
        }else {      
            if (result == false){
                Ext.Msg.alert(
                        '<s:message code="plugin.agendaMultifuncion.nuevaAnotacion.errorCamposObligatorios.title" text="**Atención"/>'
                        ,'<s:message code="plugin.agendaMultifuncion.nuevaAnotacion.errorCamposObligatorios.body" text="**Debe informar todos los campos obligatorios"/>'
                );
            } else {
            	if ( cumpleTamMax == false){
            		result =false;
            		Ext.Msg.alert(
                        '<s:message code="plugin.agendaMultifuncion.nuevaAnotacion.errorCamposObligatorios.title" text="**Atención"/>'
                        ,'<s:message code="plugin.agendaMultifuncion.nuevaAnotacion.errorTamanyoMaximo.body" text="**Los adjuntos superan el tamaño máximo permitido"/>'
                );
            	}
            }
        }
        
        return result;
    };
    
    
    var botonCrearAnotacion = new Ext.Button({
        text:'<s:message code="plugin.agendaMultifuncion.nuevaAnotacion.botonCrear" text="**Anadir"/>'
        ,iconCls:'icon_ok'
        ,handler: function() {
            
            mailAsunto.focus();
            var adjuntosList=incluirAdjuntos();
            
            if (!validar() ) {
                return false;
            }
            var storeUserList = usuariosStore.data.items;
            var paramUserList = [];
            
            var i;
            for (i=0;i< storeUserList.length;i++) {
                var storeUser = storeUserList[i].data;
                var paramUser;
                paramUser = storeUser.id;
                paramUser += '#' + storeUser.incorporar;
                if (storeUser.fecha) {
                    paramUser += '#' + storeUser.fecha.format('d/m/Y');
                } else {
                    paramUser += '#';
                } 
                
                    
                paramUser += '#' + storeUser.email;
             //    paramUser += '#' + storeUser.oficina;
                paramUserList.push(paramUser);
            }
            
            
            var fechaTodasString='';
            if (fechaTodas.getValue()) {
                fechaTodasString = fechaTodas.getValue().format('d/m/Y');
            }
            
            var params = {
                idUg: idUg
                ,codUg: codUg
                ,usuarios: paramUserList

                ,para:mailPara.getValue()
                ,cc:mailCC.getValue()

                ,asuntoMail:mailAsunto.getValue()
                ,cuerpoEmail:cuerpoEmail.getValue()
                ,tipoAnotacion:tipo.getValue()
                ,fechaTodas:fechaTodasString
                ,adjuntosList: adjuntosList
           };
            
           
           Ext.Ajax.request({
               url:'/'+app.getAppName()+'/recoveryagendamultifuncionanotacion/createAnotacion.htm'
               ,params:params
               ,success: function(response, opt) {
                   page.fireEvent(app.event.DONE);
               }
               ,failure: function(response, opt) {
                   Ext.Msg.alert(
                           '<s:message code="plugin.agendaMultifuncion.nuevaAnotacion.errorCreando.title" text="**Error"/>'
                           ,'<s:message code="plugin.agendaMultifuncion.nuevaAnotacion.errorCreando.body" text="**Se ha producido un error desconocido y no se creado la anotación"/>'
                   );
               }
           });
            
           
        }
    });

	var panel = new Ext.Panel({
		bodyStyle:'padding:10px'
		,layout: 'form'
		,autoScroll:true
		,width: maxWidth
		,border: false
		,items:[gridUsuarios, mailPara, mailCC, mailAsunto, columnas, etiquetaErrorAdjuntos, panelAdjuntos]
	    ,bbar:[botonCrearAnotacion,'->', botonCerrar]
	});
	
	var panel2 =  new Ext.Panel({
		bodyStyle:'padding:10px'
		,layout: 'form'
		,width: maxWidth
		,items:[panel]
	});
			
	page.add(panel2);
	
	Ext.onReady(
	 	function(){
	 		tipoAnotacionStore.webflow();
	 	}
	);
	
	var cargaGrid = function() {
		<%--
	    var gestoresData = <json:array name="data" items="${listaGestores}" var="d">
	        <json:object>
	            <json:property name="id" value="${d.id}"/>
	            <json:property name="username" value="${d.username}"/>
	            <json:property name="nombre" value="${d.nombre}"/>
	            <json:property name="perfil" value="${d.perfil}"/>
	            <json:property name="oficina" value="${d.oficina}"/>
	            <json:property name="incorporar" value="0"/>
	            <json:property name="fecha" value=""/>
	            <json:property name="email" value="0"/>
	        </json:object>
	    </json:array>--%>
	     var gestoresData = <json:array name="data" items="${listaGestores}" var="d">
	        <json:object>
	            <json:property name="id" value="${d.id}"/>
	            <json:property name="username" value="${d.username}"/>
	            <json:property name="nombre" value="${d.nombre}"/>
	            <json:property name="tieneEmail" value="${d.tieneEmail}"/>
	            <json:property name="incorporar" value="0"/>
	            <json:property name="fecha" value=""/>
	            <json:property name="email" value="0"/>
	        </json:object>
	    </json:array>
	    usuariosStore.loadData({data:gestoresData});
	    totalUserRows = gridUsuarios.getStore().getCount();
	    
	}
	cargaGrid.defer(1);    
</fwk:page>