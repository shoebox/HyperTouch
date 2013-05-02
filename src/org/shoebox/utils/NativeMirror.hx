package org.shoebox.utils;

import haxe.macro.Expr;
import haxe.macro.Context;

/**
 * ...
 * @author shoe[box]
 */

class NativeMirror{

	private static inline var JNI_META : String = 'JNI';
	private static inline var CPP_META : String = 'CPP';

	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		public function new() {
			
		}
	
	// -------o public
				
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		static public function build( ) : Array<Field> {
			
			//
				var aPackage   = haxe.macro.Context.getLocalClass( ).get( ).pack;
				var fields     = haxe.macro.Context.getBuildFields( );
			
			//
				var bCPP           : Bool;
				var bJNI           : Bool;
				var meta;
				var sClassName     : String = Std.string( Context.getLocalClass( ).get( ).name );
				var sFullClassName : String;
				var sLibName       : String;
				var sMethodName    : String;
				for( field in fields ){

					//
						if( field.meta == null )
							continue;

					//
						meta = null;
						bJNI = false;
						bCPP = false;
						for( m in field.meta ){
							if( m.name == JNI_META ){
								meta = m;
								bJNI = true;
							}else if( m.name == CPP_META ){
								meta = m;
								bCPP = true;
							}
							break;
						}

					//No meta
						if( !bJNI && !bCPP )
							continue;

					//Class Name
						if( bJNI ){
							if( meta.params[0] == null )
								sFullClassName = Std.string( aPackage.join('.') + (( aPackage.length == 0 ) ? '' : '.') + sClassName );
							else
								sFullClassName = _get_string( meta.params[ 0 ] );
						}else if( bCPP ){

							if( meta.params[ 0 ] == null )
								Context.error( "Error: CPP meta does not defined the libName for the method "+sMethodName+' on call '+sClassName , Context.currentPos( ) );

							sLibName = _get_string( meta.params[ 0 ] );
						}
					
					//Method name
						if( meta.params[ 1 ] == null )
							sMethodName = field.name;
						else
							sMethodName = _get_string( meta.params[ 1 ] );

					//New class variable ( used for JNI / CPP  method instance )
						var sNewVar_name : String = '_native_'+field.name;
						var newField : Field = { 
													name : sNewVar_name ,  
													doc : null, 
													meta : [], 
													access : [APublic,AStatic], 
													kind : FVar(TPath({ pack : [], name : "Dynamic", params : [], sub : null }),null), 
													pos : haxe.macro.Context.currentPos() 
												};
						fields.push( newField );

					//Creating the function expr
						var b : Bool = _is_static_method( field.access ) ;
						switch( field.kind ){

							case FFun( f ):
								f.expr = _build_func( 
														sNewVar_name , 
														bJNI ? true : false , 
														bCPP ? true : false , 
														f , 
														bCPP ? sLibName : sFullClassName , 
														sMethodName, 
														b ? true : false
													);
								
							default:

						}

				}

			return fields;
		}

		
	// -------o protected
	
		/**
		* 
		* 
		* @private
		* @return	void
		*/
		static inline private function _build_func( 
														field_name       : String , 
														bJNI             : Bool , 
														bCPP             : Bool , 
														f                : Function , 
														sFull_class_name : String , 
														sMethodName      : String , 
														bStatic          : Bool 
													) : Expr{
			
			#if verbose
			Sys.println("[NativeMirror] on "+sFull_class_name+" - Method : "+field_name);
			#end

			var b = false;
			var field = rv( field_name );
			var sMethod_name : String = Std.string( sMethodName );

			//JNI
				//Static
				var sJNI_signature  : String = "";
				var sJNI_class_name : String = "";
				
				//Arguments signature

				sJNI_signature = '(';
				var inc = 0;
				for( arg in f.args ){

					//In non static mode the first argument is ignore, it's the class instance
						if( inc++ == 0 && !bStatic )
							continue;

					//
						var oType : TypePath = null;
						var sTmp = null;
						switch( arg.type ){

							case TPath( t ):
								oType = t;
								sTmp  = t.name;
							
							default:
						}
						sJNI_signature += switch( sTmp ){

							case 'Int':
								'I';

							case 'Bool':
								'Z';

							case 'String':
								'Ljava/lang/String;';

							case 'Void':
								'V';

							default:
								switch( Context.getType( oType.name ) ){

									case TInst( t , p ) : 
										'L'+t.toString( ).split('.').join('/')+';';

									default : null;					
								}

						}
						
				}
				sJNI_signature += ')'+_jni_translate_type( _get_package_return_type( f.ret ) );

				if( bJNI )
					Sys.println("[NativeMirror] JNI Class : "+sFull_class_name+" | Method : "+sMethodName+" | Signature : "+sJNI_signature);

				sJNI_class_name = sFull_class_name.split('.').join('/');						

			//CPP
				if( bCPP )
					Sys.println("[NativeMirror] CPP Class : "+sFull_class_name+" | Method : "+sMethodName);
				
				
			//Return Expr
				
				var eRet = macro "";
				var sRet = "";
				var sType_name : String = switch( f.ret ){
				
									case TPath( t ):
										sRet = t.name;

									default:
								}

				switch( sRet ){

					case "null":
					case "Void":
						
					default:
						//TODO : Temporary should change the return type only for non basic return types
						f.ret = TPath({ name : "Dynamic" , pack : [], params : [], sub : null }); //Switching the return type to Dynamic 

						//Final return Expr
						eRet = macro return res;					
				}
			
			//Call Expr
				var eCall : Expr = macro "";
				var count = f.args.length;
				switch( f.args.length ){

					case 0:
						eCall = macro res = $field( );

					case 1:
						var v0 = rv( f.args[ 0 ].name );
						eCall = macro res = $field( $v0 );

					case 2:
						var v0 = rv( f.args[ 0 ].name );
						var v1 = rv( f.args[ 1 ].name );
						eCall = macro res = $field( $v0 , $v1 );

					case 3:
						var v0 = rv( f.args[ 0 ].name );
						var v1 = rv( f.args[ 1 ].name );
						var v2 = rv( f.args[ 2 ].name );
						eCall = macro res = $field( $v0 , $v1 , $v2 );


					case 4:
						var v0 = rv( f.args[ 0 ].name );
						var v1 = rv( f.args[ 1 ].name );
						var v2 = rv( f.args[ 2 ].name );
						var v3 = rv( f.args[ 3 ].name );
						eCall = macro res = $field( $v0 , $v1 , $v2 , $v3);


					case 5:
						var v0 = rv( f.args[ 0 ].name );
						var v1 = rv( f.args[ 1 ].name );
						var v2 = rv( f.args[ 2 ].name );
						var v3 = rv( f.args[ 3 ].name );
						var v4 = rv( f.args[ 4 ].name );
						eCall = macro res = $field( $v0 , $v1 , $v2 , $v3 , $v4 );

					case 6:
						var v0 = rv( f.args[ 0 ].name );
						var v1 = rv( f.args[ 1 ].name );
						var v2 = rv( f.args[ 2 ].name );
						var v3 = rv( f.args[ 3 ].name );
						var v4 = rv( f.args[ 4 ].name );
						var v5 = rv( f.args[ 4 ].name );
						eCall = macro res = $field( $v0 , $v1 , $v2 , $v3 , $v4 , $v5 );
				}

			//Result

				return macro {

					//Method call result
						var res : Dynamic = null;

					//For CPP		
						if( $(bCPP) ){
							 Sys.println('[CPP] ------------------------------------------------');
							 Sys.println('\tLIBRARY 		: '+$(sFull_class_name));
							 Sys.println('\tMETHOD 		: '+$(sMethod_name));
							if( $field == null ){
								#if verbose
								Sys.println('CPP Method not yet created, lets create it...');
								#end
								$field = cpp.Lib.load( $(sFull_class_name) , $(sMethod_name) , $(count) );
							}else{
								#if verbose
								Sys.println('>> CPP Method already created');
								#end
							}

							if( $field == null )
								throw new nme.errors.Error("Method creation failed");

							//res = Reflect.callMethod( null , $field , aArgs );							
						}
					
					//For JNI 
						
						if( $(bJNI) ){
							#if android
							if( $field == null ){
								if( $(bStatic) )
									$field = nme.JNI.createStaticMethod( $(sJNI_class_name) , $(sMethodName) , $(sJNI_signature) );
								else
									$field = nme.JNI.createMemberMethod( $(sJNI_class_name) , $(sMethodName) , $(sJNI_signature) );
							
								if( $field == null )
									throw new nme.errors.Error("Error creation failed");

								#if verbose
								Sys.println('>> JNI Method created');
								#end

							}else{
								#if verbose
								Sys.println('>> JNI Method already created');
								#end
							}
							#end
							//res = Reflect.callMethod( null , $field , aArgs );
						}
						

					//
						if( $field != null ){
							$eCall;
						}


					//Return Expr
						$eRet;					
				};
			
	    	
		}	

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		inline static private function _is_static_method( a : Array<Access> ) : Bool{

			var b = false;
			for( acc in a ){
				if( acc == AStatic ){
					b = true;
					break;
				}
			}

			return b;
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		static private function _get_string( e : Expr ) : String{

			var res = switch( e.expr ){

				case EConst( c ):
					switch( c ){

						case CString( s ):
							s;

						default:
							null;
					}

				default:

			}

			return res;

		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		static private function _get_package_return_type( t : ComplexType ) : String{
			
			var sType_name : String = switch( t ){
				
									case TPath( t ):
										t.name;

									default:
								}
			
			return switch( sType_name ){

				case 'Void':
					'Void';

				case 'Bool':
					'Bool';

				case 'Int':
					'Int';

				case 'String':
					'String';

				default:
					switch( Context.getType( sType_name ) ){

						case TInst( t , p ):
							t.toString( );

						default:
							Context.error("Unknowed type ::: "+sType_name , Context.currentPos( ) );

					}
			}
			
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		inline static private function _jni_translate_type( s : String ) : String{
			
			var sRes = '';
			switch( s ){

				case 'Int':
					sRes = 'I';

				case 'Bool':
					sRes = 'Z';

				case 'String':
					sRes = 'Ljava/lang/String;';

				case 'Void':
					sRes = 'V';

				default:
					sRes = 'L'+s.split('.').join('/')+';';

			}
			return sRes;
		}

	// -------o misc
		
		static function rv(variable_name:String) : Expr{
			 return { expr: EConst(CIdent(variable_name)), pos: Context.currentPos() };
		}

}