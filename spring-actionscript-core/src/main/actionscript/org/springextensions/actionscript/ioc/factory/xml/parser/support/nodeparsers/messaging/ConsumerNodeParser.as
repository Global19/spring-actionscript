/*
 * Copyright 2007-2010 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.springextensions.actionscript.ioc.factory.xml.parser.support.nodeparsers.messaging {
	
	import mx.messaging.Consumer;
	
	import org.as3commons.lang.ClassUtils;
	import org.springextensions.actionscript.ioc.IObjectDefinition;
	import org.springextensions.actionscript.ioc.factory.xml.parser.support.ParsingUtils;
	import org.springextensions.actionscript.ioc.factory.xml.parser.support.XMLObjectDefinitionsParser;
	
	/**
	 * @docref xml-schema-based-configuration.html#the_messaging_schema
	 * @author Christophe Herreman
	 */
	public class ConsumerNodeParser extends AbstractConsumerNodeParser {
		
		public static const SELECTOR_ATTR:String = "selector";
		
		public static const SUBTOPIC_ATTR:String = "subtopic";
		
		public function ConsumerNodeParser() {
		}
		
		override protected function parseInternal(node:XML, context:XMLObjectDefinitionsParser):IObjectDefinition {
			var result:IObjectDefinition = IObjectDefinition(super.parseInternal(node, context));
			
			result.className = ClassUtils.getFullyQualifiedName(Consumer, true);
			mapProperties(result, node);
			
			return result;
		}
		
		override protected function mapProperties(objectDefinition:IObjectDefinition, node:XML):void {
			super.mapProperties(objectDefinition, node);
			ParsingUtils.mapProperties(objectDefinition, node, SELECTOR_ATTR, SUBTOPIC_ATTR);
		}

	}
}