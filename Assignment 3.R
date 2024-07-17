
#Import libraries
library("ggplot2")
library("tidyverse")
library("DescTools")

#half basketball court
court <- ggplot(data = data.frame(0,0), xlim=c(0,50), ylim=c(0,47)) +
  geom_segment(aes(x = 0, y = 0, xend = 50, yend = 0)) +
  geom_segment(aes(x = 0, y = 0, xend = 0, yend = 47)) +
  geom_segment(aes(x = 50, y = 0, xend = 50, yend = 47)) +
  geom_segment(aes(x = 50, y = 47, xend = 0, yend = 47)) +
  
  #Three point line:
  geom_segment(aes(x = 3, y = 0, xend = 3, yend = 14)) +
  geom_segment(aes(x = 47, y = 0, xend = 47, yend = 14)) +
  geom_curve(aes(x = 3, y = 14, xend = 47, yend = 14), ncp = 100, curvature = -0.71) +
  
  #Center circle
  geom_curve(aes(x = 19, y = 47, xend = 31, yend = 47), ncp = 10, curvature = 0.8) +
  geom_curve(aes(x = 23, y = 47, xend = 27, yend = 47), ncp = 10, curvature = 0.8) +
  
  #Key
  geom_segment(aes(x = 17, y = 0, xend = 17, yend = 19)) +
  geom_segment(aes(x = 33, y = 0, xend = 33, yend = 19)) +
  geom_segment(aes(x = 17, y = 19, xend = 33, yend = 19)) +
  geom_segment(aes(x = 19, y = 0, xend = 19, yend = 19)) +
  geom_segment(aes(x = 31, y = 0, xend = 31, yend = 19)) +
  geom_curve(aes(x = 19, y = 19, xend = 31, yend = 19), ncp = 10, curvature = -1)  +
  geom_curve(aes(x = 19, y = 19, xend = 31, yend = 19), ncp = 10, curvature = 1)  +
  
  #Backboard and basket
  geom_segment(aes(x = 22, y = 4, xend = 28, yend = 4)) +
  geom_curve(aes(x = 25, y = 4, xend = 25, yend = 5.5), ncp = 10, curvature = -1) +
  geom_curve(aes(x = 25, y = 5.5, xend = 25, yend = 4), ncp = 10, curvature = -1) +
  
  #Restricted Area
  geom_curve(aes(x = 21, y = 4, xend = 29, yend = 4), ncp = 10, curvature = -1.1) +
  
  #Rename axis
  xlab("Court Width") +
  ylab("Court Length") +
  # fixed aspect ratio
  coord_equal() +
  # black and white theme
  theme_bw()

court

#Import Dataset
lakers_data <- read_csv("lakers.csv", show_col_types = FALSE)

#Choose Lakers Team
lakers_data <- lakers_data %>%
  filter(team == "LAL")

lakers_data$player <- gsub("Sun Yue","Yue Sun", lakers_data$player)

#Shot attempt
shot <- lakers_data %>%
  filter(etype == "shot") 

#Combining categories
shot <- shot %>%
  mutate(shot_type = case_when(
    shot$type %like% "%3pt%" ~ "3 Point Shot",
    shot$type %like% "%dunk%" ~ "Dunk",
    shot$type %like% "%hook%" ~ "Hook Shot",
    shot$type %like% "%jump%" ~ "Jump Shot",
    shot$type %like% "turnaround fade away" ~ "Jump Shot",
    shot$type %like% "%bank%" ~ "Bank Shot",
    shot$type %like% "%layup%" ~ "Layup",
    shot$type %like% "%tip%" ~ "Tip"
  )
)

#Total shot attempt for each player
Total_shot <- shot %>% 
  group_by(player) %>%
  summarise(total_shots = sum(etype == "shot")) %>%
  arrange(desc(total_shots))

#Shot characteristics for each player
court + 
  geom_jitter(data = filter(shot, result == "made"), size = 0.7, aes(x = x, y = y, color = shot_type)) + 
  facet_wrap(~player, labeller = labeller(player = label_wrap_gen(18))) + 
  ggtitle("Types of FG Attempted")

#Shot Outcome
court + geom_jitter(data = filter(shot, y <= 47), size = 0.7, mapping = aes(x = x, y = y, color = result)) + 
  facet_wrap(~player, labeller = labeller(player = label_wrap_gen(18))) + 
  ggtitle("Outcome of FG Attempted")

#Made Shot
court + 
  geom_jitter(data = filter(shot, result == "made"), size = 0.7, aes(x = x, y = y), color = "red") + 
  facet_wrap(~player, labeller = labeller(player = label_wrap_gen(18))) + 
  ggtitle("Position of FG Made")


#Two point attempt
two_point_attempt <- shot %>% 
  filter(shot_type != "3 Point Shot") %>%
  group_by(player) %>%
  summarise(Two_point_attempt = sum(etype == "shot"))

two_point_made <- shot %>%
  filter(shot_type != "3 Point Shot") %>%
  group_by(player) %>%
  summarise(two_point_made = sum(result == "made"))

two_point_efficiency <- shot %>%
  filter(shot_type != "3 Point Shot") %>%
  group_by(player) %>%
  summarise(two_point_percentage = sum(result == "made")/sum(etype == "shot") * 100)

#Three point attempt
three_point_attempt <- shot %>% 
  filter(shot_type == "3 Point Shot") %>%
  group_by(player) %>%
  summarise(Three_point_attempt = sum(etype == "shot"))

three_point_made <- shot %>%
  filter(shot_type == "3 Point Shot") %>%
  group_by(player) %>%
  summarise(three_point_made = sum(result == "made"))

three_point_efficiency <- shot %>%
  filter(shot_type == "3 Point Shot") %>%
  group_by(player) %>%
  summarise(three_point_percentage = sum(result == "made")/sum(etype == "shot") * 100)

points_scored <- lakers_data %>%
  group_by(player) %>%
  summarise(points = sum(points))

free_throw_amount <- lakers_data %>%
  filter(etype == "free throw") %>%
  group_by(player) %>%
  summarise(free_throw_attempt = sum(etype == "free throw"))


Total_efficiency <- full_join(two_point_attempt, two_point_made, by = c("player")) %>% 
  left_join(., two_point_efficiency, by = c("player")) %>%
  left_join(., three_point_attempt, by = c("player")) %>%
  left_join(., three_point_made, by = c("player")) %>%
  left_join(., three_point_efficiency, by = c("player")) %>%
  left_join(., points_scored, by = c("player")) %>%
  left_join(., Total_shot, by = c("player")) %>%
  left_join(., free_throw_amount, by = c("player")) %>%
  replace(is.na(.), 0) %>% #Clean up all NA field, replace with 0 in this scenario
  mutate(true_shooting_percentage = (0.5*points)/(total_shots + 0.44*free_throw_attempt)*100) %>%
  mutate(effective_field_goal_percentage = (two_point_made + 1.5*three_point_made)/total_shots * 100)

#From Total Shot Dataframe, top three key player on offense can be determined by amount of shot taken.

important_player <- shot %>%
  filter(player == "Kobe Bryant" | player == "Pau Gasol"| player == "Lamar Odom")

court + 
  geom_jitter(important_player, size = 1, mapping = aes(x = x, y = y, color = player))

#Compare to League Average Efficiency

#Two Point
ggplot(two_point_efficiency, aes(x = player, y = two_point_percentage)) + 
  geom_bar(stat = "identity", fill = "lightblue")  + guides(x =  guide_axis(angle = 30)) + 
  geom_hline(yintercept = 48.5, linetype='dotted', col = 'red') + 
  annotate("text", y = 48.5, x = "Derek Fisher", label = "League Average Percentage(48.5%)", vjust = -0.5) + 
  labs(x = xlab("Player"), y = ylab("Percentage"), title = ggtitle("Two Point Percentage for each player compare to League Average"))

#Three Point
ggplot(three_point_efficiency, aes(x = player, y = three_point_percentage)) + 
  geom_bar(stat = "identity", fill = "lightblue")  + guides(x =  guide_axis(angle = 30)) + 
  geom_hline(yintercept = 36.7, linetype='dotted', col = 'red') + 
  annotate("text", y = 36.7, x = "Derek Fisher", label = "League Average Percentage(36.7%)", vjust = -0.5) + 
  labs(x = xlab("Player"), y = ylab("Percentage"), title = ggtitle("Three Point Percentage for each player compare to League Average"))

#eFG
ggplot(Total_efficiency, aes(x = player, y = effective_field_goal_percentage)) + 
  geom_bar(stat = "identity", fill = "lightblue")  + guides(x =  guide_axis(angle = 30)) + 
  geom_hline(yintercept = 50, linetype='dotted', col = 'red') + annotate("text", y = 50, x = "Derek Fisher", label = "League Average Percentage(50%)", vjust = -0.5) + 
  labs(x = xlab("Player"), y = ylab("Percentage"), title = ggtitle("Effective Field Goal Percentage for each player compare to League Average"))

#True Shooting
ggplot(Total_efficiency, aes(x = player, y = true_shooting_percentage)) + 
  geom_bar(stat = "identity", fill = "lightblue")  + guides(x =  guide_axis(angle = 30)) + 
  geom_hline(yintercept = 54.4, linetype='dotted', col = 'red') + annotate("text", y = 54.4, x = "Derek Fisher", label = "League Average Percentage(54.4%)", vjust = -0.5) + 
  labs(x = xlab("Player"), y = ylab("Percentage"), title = ggtitle("True Shooting Percentage for each player compare to League Average"))


#Kobe Bryant
court + 
  geom_jitter(filter(important_player, player == "Kobe Bryant" & y <= 47), size = 1, mapping = aes(x = x, y = y), color = "red") + 
  ggtitle("Shot Distribution of Kobe Bryant") + coord_equal()

court + 
  geom_jitter(filter(shot, result == "made" & player == "Kobe Bryant"), size = 1, mapping = aes(x = x, y = y, color = shot_type)) + 
  ggtitle("Shot Distribution of Kobe Bryant by Type")

#Pau Gasol
court + 
  geom_jitter(filter(important_player,player == "Pau Gasol" & y <= 47), size = 1, mapping = aes(x = x, y = y), color = "blue") + 
  ggtitle("Shot Distribution of Pau Gasol") + coord_equal()

court + 
  geom_jitter(data = filter(shot, result == "made" & player == "Pau Gasol"), size = 1, aes(x = x, y = y, color = shot_type)) + 
  ggtitle("Shot Distribution of Pau Gasol by Type")

#Lamar Odom
court + 
  geom_jitter(filter(important_player,player == "Lamar Odom" & y <= 47), size = 1, mapping = aes(x = x, y = y), color = "green") + 
  ggtitle("Shot Distribution of Lamar Odom") + coord_equal()

court + 
  geom_jitter(data = filter(shot, result == "made" & player == "Lamar Odom"), size = 1, aes(x = x, y = y, color = shot_type)) + 
  ggtitle("Shot Distribution of Lamar Odom by Type")
