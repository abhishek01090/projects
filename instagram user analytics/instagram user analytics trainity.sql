# A) marketing analysis 
# 	1) loyal user reward

use ig_clone;

select * from users
order by created_at asc
limit 5;



# 	2) Inactive User engagement
select * from users;
select * from photos;

select username, image_url from users
left join 
photos on users.id = photos.user_id
where photos.user_id is null;
 
# 	3) Contest winner declaration 

select * from users;
select * from photos;
select * from likes;

select username, photos.id, image_url, 
count(*) as total
from photos 
left join 
likes on photos.id = likes.photo_id
left join 
 users on users.id = photos.user_id
 group by photos.id
 order by total desc
 limit 1;
 
 
# 	4) Hashtag research

select * from photo_tags;
select * from tags;

select tag_name, id,count(tag_id) as num_of_times_used
from tags
left join 
photo_tags on tags.id = photo_tags.tag_id
group by tag_name
order by num_of_times_used desc
limit 5;


# 5) Ad campaign launch

select * from users;
 
select count(*) as total,date_format(created_at, '%W') as day_of_the_week
from users
group by day_of_the_week
limit 2;

# B) investors metrics:
#	1) User engagement

select * from users;
select * from photos;

select
 (select count(*) from photos) / (select count(*) from users) as avg ;


# 2) bots and fake account

#select * from likes 
#select * from photos;




select user_id, count(photo_id)
from likes
group by user_id
having count(photo_id) =
	(select count(id) 
    from photos);
    