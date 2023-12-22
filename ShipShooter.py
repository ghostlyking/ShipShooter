# Import and initialize the pygame library
import pygame
import random

pygame.init()

# Game state
state_start_screen = 1
state_game = 2
state_game_over = 3

game_state = state_start_screen

# Star colours and sizes
starColours = [(255,255,255), (200,200,200), (150,150,150)]
starSpeeds = [0.12,0.06, 0.03]
starSizes = [2,1.5,1]

# Set up the drawing window
screen = pygame.display.set_mode([500, 600])

pygame.display.set_caption('Ship Shooter')

ship = pygame.image.load('images/GoodShip.png')
missile = pygame.image.load('images/Missile.png')
alien = pygame.image.load('images/BadShip.png')
alien = pygame.transform.flip(alien, False,True)

running = True

score = 0

shipX = 250
shipY = 550

alienX = 250
alienY = 0 

coords = []
stars = []
clock = 0

text_font = pygame.font.SysFont("Courier", 20)

def draw_text(text, font, text_col, x, y):
    img = font.render(text, True, text_col)
    screen.blit(img, (x, y))

def draw_stars():
    # Move stars
    global stars
    starTemp = []

    for (x,y,t) in stars:
            pygame.draw.circle(screen, starColours[t], (x,y), starSizes[t])

            if y < 600:
                starTemp = starTemp + [(x,y+starSpeeds[t],t)]


    if (clock % 15 == 0):
        nx = random.randint(1,500)
        ny = 0
        nt = random.randint(0,29)
        if (nt < 5):
            nt = 2
        elif (nt < 15):
            nt = 1
        else:
            nt = 0
        starTemp = starTemp + [(nx,ny,nt)]

    stars = starTemp

def draw_game():

    global ship, alien, score, shipX, shipY, alienX, alienY, coords

    screen.blit(ship, (shipX-32,shipY))
    screen.blit(alien, (alienX-32,alienY))
    
    alienY = alienY+0.125
    
    # Move missiles
    tempList = []

    for (x,y) in coords:
        screen.blit(missile, (x-32,y))
        if abs(alienX-x) < 64 and abs(alienY - y) < 64:
            alienY = -100
            y = -70
            score = score + 175
            alienX = random.randint(32,450)


        if y > 1:
            tempList = tempList + [(x,y-0.5)]

    coords = tempList    

    if alienY>600:
        score = score - 50
        alienY = -150
        alienX = random.randint(32,450)


    # Flip the display
    draw_text("Score = " + str(score), text_font, (255,255,255), 10, 10)

pygame.mouse.set_visible(False)

keypressed = False

while running:
    clock = clock + 1
    pos = pygame.mouse.get_pos()

    # Did the user click the window close button?
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            running = False

        if event.type == pygame.KEYDOWN:
            keypressed = True
            if event.key == pygame.K_ESCAPE:
                running = False
            if event.key == pygame.K_SPACE:
                if len(coords) < 3:
                    coords = coords + [(shipX,shipY)]

                

    shipX = pos[0]

    # Fill the background with white
    screen.fill((0, 0, 0))

    if game_state == state_start_screen:
        draw_stars()
        draw_text("Space conqueror", text_font, (255,255,255), 155, 100)
        draw_text("Any key to start", text_font, (255,255,255), 150, 200)
        if keypressed:
            keypressed = False
            game_state = state_game
            score = 0
            stars = []
            coords = []


    elif game_state == state_game:
        draw_stars()
        draw_game()
        if score < 0:
            game_state = state_game_over
    
    elif game_state == state_game_over:
        draw_stars()
        draw_text("Game Over", text_font, (255,255,255), 100, 100)
        draw_text("Gotta do better than that", text_font, (255,255,255), 100, 200)
        if keypressed:
            keypressed = False
            game_state = state_start_screen
    

    keypressed = False
    pygame.display.flip()

# Done! Time to quit.
pygame.quit()

