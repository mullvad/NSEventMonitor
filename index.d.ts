export class NSEventMonitor {
  start(eventMask: number, handler: Function): void;
  stop(): void;
}

export namespace NSEventMask {
  const leftMouseDown: number;
  const leftMouseUp: number;
  const rightMouseDown: number;
  const rightMouseUp: number;
  const mouseMoved: number;
  const leftMouseDragged: number;
  const rightMouseDragged: number;
  const mouseEntered: number;
  const mouseExited: number;
  const keyDown: number;
  const keyUp: number;
  const flagsChanged: number;
  const appKitDefined: number;
  const applicationDefined: number;
  const periodic: number;
  const cursorUpdate: number;
  const scrollWheel: number;
  const tabletPoint: number;
  const tabletProximity: number;
  const otherMouseDown: number;
  const otherMouseUp: number;
  const otherMouseDragged: number;
  const gesture: number;
  const magnify: number;
  const swipe: number;
  const rotate: number;
  const beginGesture: number;
  const endGesture: number;
  const smartMagnify: number;
  const maskPressure: number;
  const directTouch: number;
  const any: number;
}
