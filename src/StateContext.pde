public class StateContext {

    private State myState;
    private Context context;

        /**
         * Standard constructor
         */
    StateContext(Context _context) 
    {
        setState(new SelectState(_context));
        this.context = _context;
    }

    public void setContext(Context _context){
        this.context = _context;
    }

    public void setStateName(String nameState){
        switch (nameState) {
            case 'circle' :
                myState = new CircleState(this.context);
            break;   

            case 'select' :
                 myState = new SelectState(this.context);
             break;   

            case 'draw' :
                  myState = new DrawningState(this.context);
              break;      

            default :
                myState = new DrawningState(this.context);
            break;    
        }
    }

    /**
     * Setter method for the state.
     * Normally only called by classes implementing the State interface.
     * 
     * Devemos criar um método setState pra cada Estado
     * @param NEW_STATE
     */
    public void setState(final State NEW_STATE) {
        myState = NEW_STATE;
    }
 
    /**
     * Mouse Actions Methods
     * @param  PVector mouse
     */
    void mousePressed()
    {
        // Seleciona o segmento em questão se for o mouse LEFT
        PVector closestPoint = new PVector();
        PVector q = new PVector(context.mouse.x, context.mouse.y);
        int selectedSegment = context.curve.findClosestPoint (context.curve.controlPoints, q, closestPoint);
        //int closestControlPointIndex  = context.curve.findControlPoint(new PVector(context.mouse.x, context.mouse.y));
        PVector closestControlPoint = context.curve.getControlPoint(selectedSegment);

        float distance = q.dist(closestPoint);

        if(distance < 10 && !(myState instanceof OverSketchState) && !(myState instanceof EditingState)){
          myState = new EditingState(this.context);
        }

        if(selectedSegment == context.curve.getNumberControlPoints() - 2 && distance < 10){
            myState = new DrawningState(this.context);
        }

        myState.mousePressed();
    }
    void mouseDragged()
    {
        myState.mouseDragged();
    }
    void mouseReleased()
    {
        myState.mouseReleased();
    }

    void keyPressed(){
        switch (context.key){
            case 'z' :
                this.context.curve.undo();
            break;         

            case 'r' :
                this.context.curve.redo();
            break;    

            // Essa tecla é específica para cada estado, entao devemos implementá-la nas classes de State
            case DELETE :
              myState.keyPressed();
            break;
        }

        myState.keyPressed();
    }
    
    void draw()
    {
        background (255);
        noFill();
        
        myState.draw();

        if(context.isPlayed()){
            context.refreshInterpolator();
            float lastTime = context.lastTime();

            if(lastTime == 0){
                context.stop();
            }else{
                float t = frameCount%int(lastTime);
                context.draw(t);
            }


        }else{
            context.draw(0.0);
        }
    }
}