<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<fwk:page>
 var millonSeparator = function(num){
								if (num==null){
									num=0;
								}
								if (num=="---"){
									return "";
								}
								if (isNaN(num)) {
									return '##ERROR: CAMPO NO NUMERICO##'
								}
								num = num.toString().replace(/\$|\,/g,'');
								//sign = (num == (num = Math.abs(num)));
								num = Math.floor(num*100+0.50000000001);
								num = Math.floor(num/100).toString();
								
								if(num.length <= 6){
									for (var i = 0; i < Math.floor((num.length-(1+i))/3); i++) {
										num = num.substring(0,num.length-(4*i+3))+ app.format.THOUSANDS_SEPARATOR 
											+ num.substring(num.length-(4*i+3));
									}
								}
								else{
									var mi = num.substring(0,num.length - 6);
									var resto = num.substring(num.length - 6);
									
									
									num = mi +','+resto.substring(0,2) +' MM';
								}
									
									
								return (num+' '+ app.EURO);
							
							};	
							
	//Usado para salvar problemas de compatibilidad de fechas con FireFox, ya que el JSON no parece que devuleva un formato de fecha estándar.
	function dateRenderer(value) {
	    var fecha = new Date(value.substr(0,10));
	    return fecha.format('d/m/Y');
	}
	
	var columnaRecord = Ext.data.Record.create([
        {name:'header'}
        ,{name:'align'}
        ,{name:'dataindex'}
        ,{name:'sortable'}
        ,{name:'width'}
        ,{name:'hidden'}
        ,{name:'type'}
    ]);

	var columns = [];
	var gridColModel = new Ext.grid.ColumnModel(columns);
	var index = 0;
	
	var columnaStore =  page.getStore({
		id:'columnaStore'
		,eventName:'listado'
		,limit:25
		,remoteSort : true
		,storeId : 'columnaStore'
		,flow : 'plugin.panelControl.letrados.columnasData'
		,reader : new Ext.data.JsonReader({root:'columna'}, columnaRecord)
	});

	var getParametros = function() {
		return {
			meta:true
			,tipo:'EXP'
			,cod:'${cod}'
			,nivel:'${nivel}'
			,idNivel:'${idNivel}'
			,cod:'${cod}'
			,nombre:'${nombre}'
			,userName:'${userName}'
			,tipoProcedimiento:'${tipoProcedimiento}'
			,tipoTarea:'${tipoTarea}'
			,letradoGestor:'${letradoGestor}'
			,campanya:'${campanya}'
			,cartera:'${cartera}'
			,lote:'${lote}'
			,idPlaza:'${idPlaza}'
			,idJuzgado:'${idJuzgado}'
			,minImporteFiltro:'${minImporteFiltro}'
			,maxImporteFiltro:'${maxImporteFiltro}'
			,rangoImporte:'${rangoImporte}'
		};
	};

	columnaStore.on('load', function(store, data, options){
			columnaStore.each(function() {
				var rec=store.getAt(index);
				visible=(rec.get('hidden')==0)?false:true;
				 switch(rec.get('type')){
			    	case 'fecha':
			    		columns[index]={header: rec.get('header'),dataIndex: rec.get('dataindex'),width: parseInt((rec.get('width'))),align: rec.get('align'),sortable:true,hidden: visible,renderer: Ext.util.Format.dateRenderer('d/m/Y')};	//app.format.dateRenderer - dateRenderer - ,renderer:dateRenderer		
			    		break;
			    	case 'numero':
			    		columns[index]={header: rec.get('header'),dataIndex: rec.get('dataindex'),width: parseInt((rec.get('width'))),align: rec.get('align'),sortable:true,hidden: visible,renderer:millonSeparator};
			    		break;			
			    	default:
			    		columns[index]={header: rec.get('header'),dataIndex: rec.get('dataindex'),width: parseInt((rec.get('width'))),align: rec.get('align'),sortable:true,hidden: visible};
			    }
	        	index++;
	      });
	      gridColModel.setConfig(columns);
	      //Solo se lanza el store de obtención de asuntos si existen
	      //sino da error por el JSON
	      if ('${totalTareas}'!=0){
	      	asuntoStore.webflow(getParametros());
	      }
	});		
    
    var obtenerTitulo=function(){
		return 'Listado de expedientes: '  + '${nombre}';
	}

	var btnExportar = new Ext.Button({
		   text:'<s:message code="plugin.panelControl.letrados.exportar.xls" text="**Exportar a Excel" />'
	       ,iconCls:'icon_exportar_csv'
	       ,handler : function(){
	         var url = page.resolveUrl('exportarcsv/expedientesCSV');
	         var params="";
    		 params='tipo=EXP&cod=' + '${cod}' + '&nivel=' + '${nivel}' + '&idNivel=' + '${idNivel}' + '&nombre=' + '${nombre}' + '&userName=' + '${userName}' + '&tipoProcedimiento=' + '${tipoProcedimiento}' + '&tipoTarea=' + '${tipoTarea}' + '&letradoGestor=' + '${letradoGestor}' + '&campanya=' + '${campanya}' + '&minImporteFiltro=' + '${minImporteFiltro}' + '&maxImporteFiltro=' + '${maxImporteFiltro}' + '&rangoImporte=' + '${rangoImporte}'+'&cartera='+'${cartera}'+'&lote='+'${lote}'+'&idPlaza='+'${idPlaza}'+'&idJuzgado='+'${idJuzgado}';
	         url += '?'+ params;
	         window.open(url);
	       }
	});
			
	var asuntoStore = page.getStore({
	 	limit:25
		,flow : 'plugin.panelControl.letrados.asuntosData'
		,reader : new Ext.data.JsonReader()
	});
 
 	 var cm = gridColModel;
 	
	 var pagingBar=fwk.ux.getPaging(asuntoStore);
	 
	 var asuntoGrid=app.crearGrid(asuntoStore,cm,{
        title:obtenerTitulo()
        ,style : 'margin-bottom:10px;padding-right:10px'
        ,autoWidth: true
        ,height:500
        ,bbar : [pagingBar,btnExportar ]
    });
	
 	asuntoGrid.on('celldblclick', function(grid, rowIndex, columnIndex, e){
    	var rec = grid.getStore().getAt(rowIndex);
    	//debugger;
        if(rec && rec.get('idasunto')){
                    var id = rec.get('idasunto');
                    var desc = rec.get('nombreAsunto');
                    var nombreTab = '';
                    app.abreAsuntoTab(id,desc,nombreTab);
        }
    });
    	
	var panelAsunto = new Ext.Panel({
		id:'panelAsunto',
        labelWidth: 50,
    	autoWidth:true,
    	autoHeight:true,
    	border:false,
        bodyStyle: 'padding:5px;',
        layout: 'column',
        items: [{
        			border:false,
    				items: [asuntoGrid]
   				}]
    });
 
    
	page.add(panelAsunto);
	
	Ext.onReady(function(){
		  columnaStore.webflow({tipo:'EXP'});
	});
	
</fwk:page>



