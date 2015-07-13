var canvas = document.getElementById('snakeCanvas');
var context = canvas.getContext('2d');

var gridSize = { rows: 15, cols: 15 };
var nodeSize = { width: Math.ceil(canvas.width / gridSize.cols), height: Math.ceil(canvas.height / gridSize.rows) };

var snake = [];
var food = {};

var snakeColor = "#09F";
var foodColor = "#F90";
var textColor = "#000";

var directions = { left: 0, up: 1, right: 2, down: 3 };
var movingDirection = directions.up;

var score = 0;

var keysDirection = { 37: directions.left, 38: directions.up, 39: directions.right, 40: directions.down };

document.addEventListener('keydown', function(event) { keyPressed(event.keyCode) });

function oppositeDirection(direction) {
	switch (direction) {
		case directions.left: return directions.right;
		case directions.up: return directions.down;
		case directions.right: return directions.left;
		case directions.down: return directions.up;
	}
}

function keyPressed(key) {
	var direction = keysDirection[key];

	if (direction != null && direction != oppositeDirection(movingDirection)) {
		movingDirection = direction;
	}
}

function createPoint(x, y) {
	return { x: x, y: y };
}

function randomPoint() {
	var x = Math.floor(Math.random() * gridSize.cols);
	var y = Math.floor(Math.random() * gridSize.rows);
	return createPoint(x, y);
}

function hasSnake(x, y, ignoresHead) {
	for (var i in snake) {
		if (ignoresHead && i == 0) { continue; }

		var point = snake[i];
		if (point.x == x && point.y == y) {
			return true;
		}
	}

	return false;
}

function pointForFood() {
	var point = randomPoint();

	while(hasSnake(point.x, point.y)) {
		point = randomPoint();
	}

	return point;
}

function startNewGame() {
	snake = [];
	food = {};
	score = 0;

	movingDirection = directions.up;

	var center = createPoint(Math.floor(gridSize.cols / 2), Math.floor(gridSize.rows / 2));
	snake.push(center);
	snake.push(createPoint(center.x, center.y + 1));
	snake.push(createPoint(center.x, center.y + 2));

	food = pointForFood();
}

function init() {
	startNewGame();

	tick();
}

function update() {
	// Move the snake body
	for (var i = snake.length - 1; i > 0; i--) {
		snake[i].x = snake[i - 1].x;
		snake[i].y = snake[i - 1].y;
	}

	// Move the snake head
	switch (movingDirection) {
		case directions.left:
			snake[0].x--;
		break;
		case directions.up:
			snake[0].y--;
		break;
		case directions.right:
			snake[0].x++;
		break;
		case directions.down:
			snake[0].y++;
		break;
	}

	// If the snake is over the food
	if (snake[0].x == food.x && snake[0].y == food.y) {
		score++;
		snake.push(createPoint(snake[snake.length - 1]));
		food = pointForFood();
	}

	// If the snake if out the grid
	if (snake[0].x < 0 || snake[0].x >= gridSize.cols || snake[0].y < 0 || snake[0].y >= gridSize.rows) {
		startNewGame();
	}

	// If the snake is over itself
	if (hasSnake(snake[0].x, snake[0].y, true)) {
		startNewGame();
	}
}

function draw() {
	// Clears the canvas
	context.clearRect(0, 0, canvas.width, canvas.height);

	// Draws snake
	context.fillStyle = snakeColor;
	for (var i in snake) {
		var point = snake[i];
		context.fillRect(point.x * nodeSize.width, point.y * nodeSize.height, nodeSize.width, nodeSize.height);
	}

	// Draws food
	context.fillStyle = foodColor;
	context.fillRect(food.x * nodeSize.width, food.y * nodeSize.height, nodeSize.width, nodeSize.height);

	// Draws score
	context.fillStyle = textColor;
	context.font = "30px Arial";
	context.fillText(score, canvas.width / 2, canvas.height / 6);
}

function tick() {
	update();
	draw();

	// 5 frames per second
	console.log("working!");
	setTimeout(tick, 1000 / 5);
}

init();