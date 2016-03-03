<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<fwk:page>

	var localidadesRecord = Ext.data.Record.create([
		{name: 'descripcion'}
	]);

	var localidadesStore = page.getStore({
		flow: 'liquidaciondoc/obtenerLocalidadesFirma',
		reader: new Ext.data.JsonReader({
			root: 'localidadesFirma'
		}, localidadesRecord)
	});
	
	var comboLocalidades = new Ext.form.ComboBox({
		store: localidadesStore,
		displayField: 'descripcion',
		valueField: 'descripcion',
		mode: 'local',
		allowBlank: false,
		forceSelection: true,
		triggerAction: 'all',
		disabled: false,
		width: 150,
		editable: true,
		emptyText:'<s:message code="rec-web.direccion.form.seleccionar" text="**Seleccionar" />',
		fieldLabel: '<s:message code="plugin.precontencioso.liquidaciones.generar.localidadFirma" text="**Localidad firma" />'
	});
	
	comboLocalidades.on('afterrender', function(combo) {
		localidadesStore.webflow();
	});
	
	
	Ext.grid.CheckColumn = function(config){
	    Ext.apply(this, config);
	    if(!this.id){
	        this.id = Ext.id();
	    }
	    this.renderer = this.renderer.createDelegate(this);
	};
                                                                                                                                                                     
	Ext.grid.CheckColumn.prototype = {
	    init : function(grid) {
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
	
	var checkColumn = new Ext.grid.CheckColumn({
	    header : '<s:message code="nuevoModeloBienes.agregarExcluirBien.grid.seleccionar" text="**Seleccionar"/>'
	    ,width:50,dataIndex:'incluido'});
	
	var bienes = Ext.data.Record.create([
         {name : 'idBien'}
        ,{name : 'codigo'}
        ,{name : 'origen'}
        ,{name : 'descripcion'}
        ,{name : 'tipo'}
        ,{name : 'solvencia'}
        ,{name : 'codSolvencia'}
        ,{name : 'incluido'}
        ,{name : 'numFinca'}
        ,{name : 'referenciaCatastral'}
        ,{name : 'numeroActivo'}
     ]);

	
   var cmBienes = new Ext.grid.ColumnModel([
      checkColumn
	    ,{header : '<s:message code="nuevoModeloBienes.agregarExcluirBien.grid.codigo" text="**C&oacute;digo" />', hidden:true, dataIndex : 'codigo'}
		,{header : '<s:message code="plugin.nuevoModeloBienes.procedimiento.embargos.grid.numeroFinca" text="**N&uacute;mero finca" />', dataIndex : 'numFinca'}
		,{header : '<s:message code="plugin.nuevoModeloBienes.procedimiento.embargos.grid.referenciaCatastral" text="**Referencia catastral"/>', dataIndex : 'referenciaCatastral' }
		<sec:authorize ifNotGranted="PERSONALIZACION-BCC">
			,{header : '<s:message code="plugin.nuevoModeloBienes.procedimiento.embargos.grid.numeroActivo" text="**N�mero activo"/>', dataIndex : 'numeroActivo' }
        </sec:authorize>
      	,{header : '<s:message code="nuevoModeloBienes.agregarExcluirBien.grid.origen" text="**Origen" />', dataIndex : 'origen'}
    	,{header : '<s:message code="nuevoModeloBienes.agregarExcluirBien.grid.descripcion" text="**Descripcion" />', dataIndex : 'descripcion'}
      	,{header : '<s:message code="nuevoModeloBienes.agregarExcluirBien.grid.tipo" text="**Tipo" />', dataIndex : 'tipo'}
      	,{header : '<s:message code="nuevoModeloBienes.agregarExcluirBien.grid.solvencia" text="**Solvencia" />', dataIndex : 'solvencia'}
   ]);
 
   var bienesStore = page.getStore({
        flow: 'expedientejudicial/bienesAsociadosProcedimiento'
        ,storeId : 'bienesStore'
        ,reader : new Ext.data.JsonReader(
            {root:'bienesPrc'}
            , bienes
        )
   });  
	
   var gridBienes = new Ext.grid.EditorGridPanel({
   		 store: bienesStore
         ,cm: cmBienes
         ,title : '<s:message code="nuevoModeloBienes.agregarExcluirBien.grid.titulo" text="**Bienes" />'
         ,style : 'margin-bottom:10px;padding-right:0px'
         ,height : 400
         ,cls:'cursor_pointer'
         ,plugins: checkColumn
         //,clickstoEdit: 'auto'
         ,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
	});
	
	var strIds = '';
	
	var comprobarSiHayFilSeleccionada=function(){
		var store = gridBienes.getStore();
		var datos;
		strIds = '';
		var numFilasSeleccionadas=0;
		for (var i=0; i < store.data.length; i++) {
			datos = store.getAt(i);
			if(datos.get('incluido') == true) {
      			numFilasSeleccionadas=numFilasSeleccionadas+1;
      			if(strIds!='') {
					strIds += ',';
				}
	      		strIds += datos.get('idBien');
			}
		}
		return numFilasSeleccionadas;
	}
	
	var btnAceptar = new Ext.Button({
	       text : '<s:message code="app.guardar" text="**Guardar" />'
			,iconCls : 'icon_ok'
	       ,cls: 'x-btn-text-icon'
	       ,handler:function(){
				if (comprobarSiHayFilSeleccionada()>=1 && comboLocalidades.getValue() != ''){
					this.instanciar();
	      		}else{
					Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="nuevoModeloBienes.agregarExcluirBien.agregar.faltanDatos" text="**Debe seleccionar alg�n bien"/>');
	      		}
	     	}
	     	,instanciar:function() {
	     		page.webflow({
		      		flow:'expedientejudicial/instanciarDocumentoBienes'
		      		,params:{idProcedimiento:data.id, idsBien:strIds}
		      		,success: function(result,request){
		      			if(result.resultadoOK=='true'){
	            			page.fireEvent(app.event.DONE);
	            			
	            			localidadFirma: comboLocalidades.getValue();
	            														
						}else{
							Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="nuevoModeloBienes.agregarExcluirBien.agregar.faltanDatos.a" text="**HAy algun campo vacio"/>');
						}
	            	}	
		      	});
	     	}
	});
		
	var btnCancelar = new Ext.Button({
	       text : '<s:message code="app.cancelar" text="**Cancelar" />'
			,iconCls : 'icon_cancel'
	       ,cls: 'x-btn-text-icon'
	       ,handler:function(){
	      		page.fireEvent(app.event.CANCEL);
	     	}
	});

	var limit=25;
	var DEFAULT_WIDTH=700;

	bienesStore.on('load', function(){
		panelAlta.el.unmask(); 
	});
	
	//-------------------------------------------------
	var panelAlta = new Ext.form.FormPanel({
		autoHeight:true
		,bodyStyle:'padding:0px;'
		,border: false
	    ,items : [{
				bodyStyle:'padding:5px;cellspacing:10px'
				,border:false
				,defaults : {xtype:'panel' ,cellCls : 'vtop'}
				,items : [comboLocalidades, gridBienes]
		  	}
		]
		,bbar : [btnAceptar, btnCancelar]
	});
 	
    bienesStore.webflow({id:data.id});
   
	page.add(panelAlta);
	panelAlta.el.mask('<s:message code="fwk.ui.form.cargando" text="**Cargando.."/>','x-mask-loading');

</fwk:page>
