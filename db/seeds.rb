require_relative '../models.rb'

2.times do
  Post.create(title:"Nam liber tempor cum soluta nobis",
              body: "Nam liber tempor cum soluta nobis eleifend option congue nihil
              imperdiet doming id quod mazim placerat facer possim assum. Lorem ipsum
              dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh
              euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi
              enim ad minim veniam, quis nostrud exerci tation ullamcorper suscipit
              lobortis nisl ut aliquip ex ea commodo consequat. "
             )

  Post.create(title:"Ut wisi enim ad minim veniam",
              body: "Ut wisi enim ad minim veniam, quis nostrud exerci tation
              ullamcorper suscipit lobortis nisl ut aliquip ex ea commodo consequat.
              Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse
              molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero
              eros et accumsan et iusto odio dignissim qui blandit praesent luptatum
              zzril delenit augue duis dolore te feugait nulla facilisi. "
             )

  Post.create(title:"Duis autem vel eum iriure dolor",
              body: "Duis autem vel eum iriure dolor in hendrerit in vulputate velit
              esse molestie consequat, vel illum dolore eu feugiat nulla facilisis
              at vero eros et accumsan et iusto odio dignissim qui blandit praesent
              luptatum zzril delenit augue duis dolore te feugait nulla facilisi.
              Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam
              nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat
              volutpat."
             )
end

Comment.create(author:"Jenas Lucas",
               post_id: 1,
               body: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed
               diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat
               volutpat.")