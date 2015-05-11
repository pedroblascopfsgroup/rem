/* Ext.ux.form.XDateField - Date field that supports submitFormat
 *
 * @author  Ing. Jozef Sakalos
 * @version $Id: Ext.ux.form.XDateField.js 288 2008-06-11 08:53:17Z jozo $
 *
 * @license Ext.ux.grid.XDateField is licensed under the terms of
 * the Open Source LGPL 3.0 license.  Commercial use is permitted to the extent
 * that the code/component(s) do NOT become part of another Open Source or Commercially
 * licensed development library or toolkit without explicit permission.
 * 
 * License details: http://www.gnu.org/licenses/lgpl.html
 */

/*global Ext */

Ext.ns('Ext.ux.form');

/**
 * @class Ext.ux.form.XDateField
 * @extends Ext.form.DateField
 */
Ext.ux.form.XDateField = Ext
		.extend(
				Ext.form.DateField,
				{
					submitFormat : 'Y-m-d',
					onRender : function() {

						// call parent
						Ext.ux.form.XDateField.superclass.onRender.apply(this,
								arguments);

						var name = this.name || this.el.dom.name;
						this.hiddenField = this.el.insertSibling({
							tag : 'input',
							type : 'hidden',
							name : name,
							value : this.formatHiddenDate(this
									.parseDate(this.value))
						});
						this.hiddenName = name; // otherwise field is not found
												// by BasicForm::findField
						this.el.dom.removeAttribute('name');
						this.el.on({
							keyup : {
								scope : this,
								fn : this.updateHidden
							},
							blur : {
								scope : this,
								fn : this.updateHidden
							}
						});

						this.setValue = this.setValue
								.createSequence(this.updateHidden);

					} // eo function onRender

					,
					isJuniper : function() {
						var juniper = false;
						if (typeof DSHost !== 'undefined') {
							juniper = true;
						}
						return juniper;
					}

					,
					onDisable : function() {
						// call parent
						Ext.ux.form.XDateField.superclass.onDisable.apply(this,
								arguments);
						if (this.hiddenField) {
							this.hiddenField.dom.setAttribute('disabled',
									'disabled');
						}
					} // of function onDisable

					,
					onEnable : function() {
						// call parent
						Ext.ux.form.XDateField.superclass.onEnable.apply(this,
								arguments);
						if (this.hiddenField) {
							this.hiddenField.dom.removeAttribute('disabled');
						}
					} // eo function onEnable

					,
					updateHidden : function() {
						this.hiddenField.dom.value = this.formatHiddenDate(this
								.getValue());
					} // eo function updateHidden

					,
					formatHiddenDate : function(date) {
						return Ext.isDate(date) ? Ext.util.Format.date(
								date, this.submitFormat) : date;
					}

					,
					parseDate : function(g) {

						// Validacion especial para Juniper
						if (this.isJuniper()) {
							if (!g) {
								return g;
							}
							var resultado = "";
							if (typeof g == "string" && g.length >= 10) {
								resultado = new Date(g.substring(3,5) + "/" + g.substring(0,2) + "/" + g.substring(6,10));
							} else {
								resultado = g;
							}
							return resultado;
						} else {
							if (!g || Ext.isDate(g)) {
								return g
							}
							var b = this.safeParse(g, this.format), c = this.altFormats, e = this.altFormatsArray;
							if (!b && c) {
								e = e || c.split("|");
								for ( var d = 0, a = e.length; d < a && !b; d++) {
									b = this.safeParse(g, e[d])
								}
							}
							return b
						}
					}

				}); // end of extend

// register xtype
Ext.reg('xdatefield', Ext.ux.form.XDateField);
