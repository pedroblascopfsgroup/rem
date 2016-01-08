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

	var cssIconDownList = 'background-image: url(\'../css/downList.png\');background-repeat:no-repeat;background-position:right;'; 
	
	var accion='${accion}';
	var idSubasta=${idSubasta};
	
	
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
	    header : '<s:message code="subastas.agregarExcluirBien.grid.seleccionar" text="**Seleccionar"/>'
	    ,width:50,dataIndex:'incluido'});
	
	

	var bienes = Ext.data.Record.create([
          {name : 'idBien'}
         ,{name : 'codigo'}
         ,{name : 'origen'}
         ,{name : 'descripcion'}
         ,{name : 'tipo'}
         ,{name : 'lote'}
         ,{name : 'incluido'}
         ,{name : 'numFinca'}
         ,{name : 'referenciaCatastral'}
         ,{name : 'numeroActivo'}
      ]);

	var numLote = new Ext.form.NumberField({allowDecimals: false
		,name:'meses'
		,allowNegative: false
		,allowBlank: false
		,width: 5
		,fieldLabel : '<s:message code="subastas.agregarExcluirBien.grid.lote" text="**Lote" />'
		,maxLength:3		
	});
	
 	var cellLoteRenderer = function(value, metaData, record, rowIndex, colIndex, store) {
		Ext.isEmpty(value)? metaData.attr = "style='background-color : #FCFF99'" : null; 
		return value;
	}
	
 var cmBienes = new Ext.grid.ColumnModel([
      checkColumn
      ,{header : '<s:message code="subastas.agregarExcluirBien.grid.codigo" text="**C&oacute;digo" />', hidden:true, dataIndex : 'codigo', width: 50}
		,{header : '<s:message code="plugin.nuevoModeloBienes.procedimiento.embargos.grid.numeroFinca" text="**N&uacute;mero finca" />', dataIndex : 'numFinca'}
		,{header : '<s:message code="plugin.nuevoModeloBienes.procedimiento.embargos.grid.referenciaCatastral" text="**Referencia catastral"/>', dataIndex : 'referenciaCatastral' }
		,{header : '<s:message code="plugin.nuevoModeloBienes.procedimiento.embargos.grid.numeroActivo" text="**N�mero activo"/>', dataIndex : 'numeroActivo' }
		,{header : '<s:message code="subastas.agregarExcluirBien.grid.descripcion" text="**Descripcion" />', dataIndex : 'descripcion', width: 250}
		,{header : '<s:message code="subastas.agregarExcluirBien.grid.tipo" text="**Tipo" />', dataIndex : 'tipo'}
      ,{header : '<s:message code="subastas.agregarExcluirBien.grid.origen" text="**Origen" />', dataIndex : 'origen'}
      ,{header : '<s:message code="subastas.agregarExcluirBien.grid.lote" text="**Lote" />', dataIndex : 'lote', menuDisabled: true, renderer: {fn: cellLoteRenderer} <c:if test="${accion=='AGREGAR'}">,editor:numLote</c:if>}      
   ]);
    
   var bienesStore = page.getStore({
        flow: 'subasta/getBienes'
        ,storeId : 'bienesStore'
        ,reader : new Ext.data.JsonReader(
            {root:'bienes'}
            , bienes
        )
   });  
	
   bienesStore.webflow({idSubasta:idSubasta, accion:accion});
   
   
   var gridBienes = new Ext.grid.EditorGridPanel({
   		 store: bienesStore
         ,cm: cmBienes
         ,title : '<s:message code="subastas.agregarExcluirBien.grid.titulo" text="**Bienes" />'
         ,style : 'margin-bottom:10px;padding-right:10px'
         ,height : 400
         ,cls:'cursor_pointer'
         ,plugins: checkColumn
         ,clicksToEdit: 1
         ,autoExpandColumn: true
         ,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
	});	
	
	var comprobarSiHayFilSeleccionada=function(){		
		var store = gridBienes.getStore();
		var datos;
		var numFilasSeleccionadas=0;
		for (var i=0; i < store.data.length; i++) {
			datos = store.getAt(i);
			if(datos.get('incluido') == true) {				
				if ((accion=='AGREGAR' && datos.get('lote') != '') || (accion=='EXCLUIR')) {
	      			numFilasSeleccionadas=numFilasSeleccionadas+1
	      		} else {
	      			// hay un error
	      			return 0;
	      		}
			}
		}
		return numFilasSeleccionadas;
	}
	
	
	var getParams = function() {
		
		var objParams = {};
		var store = gridBienes.getStore();
		var strIds = '';
		var strLotes = '';
		var datos;
		for (var i=0; i < store.data.length; i++) {
			datos = store.getAt(i);
			if(datos.get('incluido') == true && datos.get('lote') != '') {
				if(strIds!='') {
					strIds += ',';
					strLotes += ',';
				}
	      		strIds += datos.get('idBien');	      		
	      		strLotes += datos.get('lote');
			}
		}
		objParams = {
			idSubasta:idSubasta,
			idsBien:strIds,
			lotes:strLotes,
			accion:accion
		}
		
		return objParams;
	}
	
	var btnAceptar = new Ext.Button({
	       text : '<s:message code="app.guardar" text="**Guardar" />'
			,iconCls : 'icon_ok'
	       ,cls: 'x-btn-text-icon'
	       ,handler:function(){
				if (comprobarSiHayFilSeleccionada()>=1){								
	      			page.webflow({
		      			flow:'subasta/guardarAgregarExcluirBien'
		      			,params: getParams()
		      			,success: function(){
	            		   page.fireEvent(app.event.DONE);
	            		}	
		      		});
	      		}else{
	      			if (accion=='AGREGAR') {
						Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="subastas.agregarExcluirBien.agregar.faltanDatos" text="**Debe seleccionar alg�n bien y el lote al que pertence"/>');
					} else {
						Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="subastas.agregarExcluirBien.excluir.faltanDatos" text="**Debe seleccionar alg�n bien"/>');
					}
	      		}
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

	var panelAlta = new Ext.form.FormPanel({
		autoHeight:true
		,bodyStyle:'padding:0px;'
		,border: false
	    ,items : [{
			bodyStyle:'padding:5px;cellspacing:10px'
			,border:false
			,defaults : {xtype:'panel' ,cellCls : 'vtop'}
			,items : [gridBienes]
		  }]
		,bbar : [btnAceptar, btnCancelar]
	});
	

	page.add(panelAlta);

</fwk:page>
