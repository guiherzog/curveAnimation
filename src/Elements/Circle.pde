class Circle extends SceneElement{

	float width, height;
	boolean active;

	Circle(float _width, float _height)
	{
		super(context.mouse);
		this.name = "Circle";
		this.width = _width;
		this.height = _height;
		active = true;
	}

	void draw(float t)
	{
		if(pos.nKeys() < 1){
			return;
		}

		if(t >= pos.keyTime(pos.nKeys()-1)){
			t = pos.keyTime(pos.nKeys()-1);
		}

		PVector position;
		if(!active){
			position = pos.get(0);
		}else{
			position = pos.get(t);
		}
		
		float myScale = this.sizeInterpolator.get(t).getSize();

		if(t == 0){
			myScale = 1;
		}

		pushMatrix();
		fill(c);
		noStroke();
		translate(position.x, position.y, 0);
		sphere(this.width * myScale);
		
		fill(0);
		sphere(5);
		popMatrix();
	}

	void setWidth(float x){
		this.width = x;
	}

	void setHeight(float x){
		this.height = x;
	}

	float lastTime()
	{
		if(pos.nKeys() < 1)
			return 0;

		return pos.interp.time.get(pos.nKeys()-1);
	}

	boolean isOver(PVector mouse){
                PVector position = pos.get(0);
                float radious = this.width;
		return (mouse.x - position.x)*(mouse.x - position.x) + (mouse.y - position.y)*(mouse.y - position.y) <= radious*radious;
	}
}
