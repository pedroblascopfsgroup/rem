<%@ page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<fwk:page>


	var Stats = new Ext.data.Record.create([
		{name : 'Label'}
		,{name : 'Number', type:'float'}
	]);

	var gridMaster = page.getStore({
		flow : 'hibernate/data'
		,reader : new Ext.data.JsonReader({
			root : 'masterStatistics'
		},Stats)
		,remoteSort : false
	});

	gridMaster.webflow();

	var gridEntity = page.getStore({
		flow : 'hibernate/data'
		,reader : new Ext.data.JsonReader({
			root : 'entityStatistics'
		},Stats)
		,remoteSort : false
	});

	gridEntity.webflow();


	var gridCm = new Ext.grid.ColumnModel([
		{header : 'Label', dataIndex : 'Label', sortable:true, width:200 }
		,{header : 'Number', dataIndex : 'Number', sortable:true, width:80 }
	]);

	var botonM1 = new Ext.Button({
		text : 'Refresh'
		,iconCls : 'fwk_recargar'
		,handler:function(){
		gridMaster.webflow();
          }
	});

	var botonM2 = new Ext.Button({
		text : 'Enable Statistics'
		,iconCls : 'icon_ok'
		,handler:function(){
			var w = app.openWindow({
						flow : 'hibernate/changeStatisticsMode1'
						,width:760
					});
			w.close();
			gridMaster.webflow();
			if(this.getText()=='Disable Statistics'){
				this.setIconClass('icon_ok');
				this.setText('Enable Statistics');
			}else{
				this.setIconClass('icon_cancel');
				this.setText('Disable Statistics');
			}

			
        }
	});

	var botonM3 = new Ext.Button({
		text : 'Clear Cache'
		,iconCls : 'icon_menos'
		,handler:function(){
			var w = app.openWindow({
						flow : 'hibernate/clearMasterCache'
						,width:760
						,title : 'Borrando cache' 
					});
			w.close();
			gridMaster.webflow();
        }
	});



	var botonE1 = new Ext.Button({
		text : 'Refresh'
		,iconCls : 'fwk_recargar'
		,handler:function(){
		gridEntity.webflow();
          }
	});

	var botonE2 = new Ext.Button({
		text : 'Enable Statistics'
		,iconCls : 'icon_ok'
		,handler:function(){
			var w = app.openWindow({
						flow : 'hibernate/changeStatisticsMode2'
						,width:760
					});
			w.close();
			gridMaster.webflow();
			if(this.getText()=='Disable Statistics'){
				this.setIconClass('icon_ok');
				this.setText('Enable Statistics');
			}else{
				this.setIconClass('icon_cancel');
				this.setText('Disable Statistics');
			}

			
        }
	});

	var botonE3 = new Ext.Button({
		text : 'Clear Cache'
		,iconCls : 'icon_menos'
		,handler:function(){
			var w = app.openWindow({
						flow : 'hibernate/clearEntityCache'
						,width:760
						,title : 'Borrando cache' 
					});
			w.close();
			gridMaster.webflow();
        }
	});

	var gridGridM = new Ext.grid.GridPanel({
		store : gridMaster
		,title : 'Master Statistics'
		,cm : gridCm
		,width : 305
		,height : 400
		,tbar : [botonM1,botonM2,botonM3]
	});

	var gridGridE = new Ext.grid.GridPanel({
		store : gridEntity
		,title : 'Entity Statistics'
		,cm : gridCm
		,width : 305
		,height : 400
		,tbar : [botonE1,botonE2,botonE3]
	});
	
	


	var panel	= new Ext.Panel({
		autoHeight : true
		,autoWidth:true
		,bodyStyle : 'padding:10px'
		,defaults: {style: 'padding:10px'} 
		,border : false
		,items : [gridGridM,gridGridE]
		,layout: 'table'
	    ,layoutConfig: {columns: 2}
	});

	page.add(panel);

</fwk:page>

<div id="mago">
<table>
<tr><td style="text-align: center;"><img src="../fwk/img/wizard.gif" /><br/><font size="1">Powered by DEVON </font></td></tr>
</table>
</div> 
