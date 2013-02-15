/*
 * Copyright 2007-2011 the original author or authors.
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
package org.springextensions.actionscript.core.task.support {

	import org.springextensions.actionscript.core.command.ICommand;
	import org.springextensions.actionscript.core.operation.IOperation;
	import org.springextensions.actionscript.core.task.ITask;
	import org.springextensions.actionscript.core.task.ITaskBlock;
	import org.springextensions.actionscript.core.task.ITaskFlowControl;
	import org.springextensions.actionscript.core.task.TaskFlowControlKind;
	import org.springextensions.actionscript.core.task.command.TaskCommand;
	import org.springextensions.actionscript.core.task.command.TaskFlowControlCommand;
	import org.springextensions.actionscript.core.task.event.TaskEvent;
	import org.springextensions.actionscript.core.task.event.TaskFlowControlEvent;


	/**
	 * Base class for <code>ITaskBlock</code> implementations.
	 * @inheritDoc
	 */
	public class AbstractTaskBlock extends Task implements ITaskBlock {

		private var _isClosed:Boolean;

		public function get isClosed():Boolean {
			return _isClosed;
		}

		public function AbstractTaskBlock() {
			super();
		}

		override protected function executeCommand(command:ICommand):void {
			currentCommand = command;
			if (command) {
				if (doFlowControlCheck(command)) {
					var async:IOperation = command as IOperation;
					addCommandListeners(async);
					dispatchTaskEvent(TaskEvent.BEFORE_EXECUTE_COMMAND, command);
					command.execute();
					if (async == null) {
						dispatchTaskEvent(TaskEvent.AFTER_EXECUTE_COMMAND, command);
						executeNextCommand();
					}
				}
			} else {
				restartExecution();
			}
		}

		protected function doFlowControlCheck(command:ICommand):Boolean {
			var tc:TaskCommand = command as TaskCommand;
			if (tc != null) {
				var flowControl:ITaskFlowControl = tc.commands[0] as ITaskFlowControl;
				if (flowControl != null) {
					return executeFlowControl(flowControl.kind);
				}
			}
			return true;
		}

		protected function executeFlowControl(kind:TaskFlowControlKind):Boolean {
			switch (kind) {
				case TaskFlowControlKind.BREAK:
					resetCommandList();
					completeExecution();
					return false;
					break;
				case TaskFlowControlKind.CONTINUE:
					restartExecution();
					return false;
					break;
				case TaskFlowControlKind.EXIT:
					exitExecution();
					return false;
					break;
				default:
					return true;
					break;
			}
		}

		protected function exitExecution():void {
			//nothing?
		}

		protected function restartExecution():void {
			resetCommandList();
			execute();
		}

		override protected function TaskFlowControlEvent_handler(event:TaskFlowControlEvent):void {
			executeFlowControl(TaskFlowControlKind.fromName(event.type));
		}

		override public function end():ITask {
			_isClosed = true;
			return (this.parent != null) ? this.parent : this;
		}

	}
}