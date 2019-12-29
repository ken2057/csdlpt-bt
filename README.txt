<video>
	Hiện tại máy em đang sử dụng docker (docker conflict với VM) nên em sẽ sử dụng docker làm 2 máy trạm

	Cài đặt:
	1 - Tạo máy trạm
	2 - Thêm DB, Link, Trigger, Quyền, SP, Data ở máy chủ và 2 máy trạm

	Test với App: 
</video>

Folder:
	./src 			: chứa script sql
	./data-log 		: chứa file mdf, ldf của máy chủ, và 2 máy trạm
	./App			: chứa App

File:
	- docker-create.bat			: tạo máy trạm trên trên docker theo image mà config sẵn
	- docker-install-db.bat		: thêm db, sp, trigger, quyền data ở máy chủ và 2 máy trạm trên docker
	- docker-remove.bat			: xoá 2 container tram1, tram2 trên docker để chạy lại từ đâu
	Trong ./src:
		- *_db.sql					: tạo db
		- *_link.sql				: tạo link server đến các trạm
		- *_sp.sql					: chứa stored procedure
		- maychu_data.sql			: chứa dữ liệu tạm, thêm ở máy chủ và gọi vào các máy trạm trên máy chủ
		- maychu_quyen.sql			: phân quyền trên máy chủ
		- tram_quyen.sql			: phân quyền trên máy trạm
		- buoi4.sql					: chứa view/sp buổi 4

App:
- connectionString được lưu trong file App.config