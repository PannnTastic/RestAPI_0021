# rest_api_0021

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# Login Page
<img width="1920" height="1200" alt="{DC8F3B21-B837-4091-8DD5-DECF695CBF9C}" src="https://github.com/user-attachments/assets/7a0b0e7e-c022-49be-9c12-c8f4c571fd80" />

# Register Page
<img width="1920" height="1200" alt="{696EA425-4E80-436C-884B-59884A07E574}" src="https://github.com/user-attachments/assets/eb273fe9-f2f4-4df9-a6a7-b702ae2a222e" />

# Dashboard
<img width="1920" height="1200" alt="{F96546A4-129B-45B5-83B1-9620BB0EB2A8}" src="https://github.com/user-attachments/assets/02bfddc0-faac-4df6-9dbc-2ceebe22fa90" />

# Add Hewan - date picker With Validation
<img width="1920" height="1200" alt="{EF96ADE4-00FE-411C-83A5-4E811CE1D117}" src="https://github.com/user-attachments/assets/8a2aed8d-c382-475b-bdfc-8aa3a8e88337" />

# Add Hewan - dropdown for truncated type safety
<img width="1920" height="1200" alt="{03328FF8-2343-406A-BBFB-3F5D43B53881}" src="https://github.com/user-attachments/assets/c6664950-a39b-475d-bf61-86a71e8740b4" />

# Add Hewan - Final
<img width="1920" height="1200" alt="{369C9D1C-3068-456C-AD14-9B172DF1CA7A}" src="https://github.com/user-attachments/assets/f4d4b8d3-6751-4f4a-8589-e2a99a63f184" />

# Dashboard - After Add Hewan
<img width="1920" height="1200" alt="{2ED7C2F0-EF5C-48A3-B526-16F7207664FC}" src="https://github.com/user-attachments/assets/ec17d0a6-7d40-4aa5-aa35-945018589940" />

# Edit Hewan
<img width="1920" height="1200" alt="image" src="https://github.com/user-attachments/assets/17a2b2fc-5f59-424a-bdb6-3f6a809ae2eb" />

# Hewan Detail
<img width="1920" height="1200" alt="{DF33A4F0-446E-4CBE-90AC-505FC3A0F332}" src="https://github.com/user-attachments/assets/c6bee51a-bd52-4fd4-a77f-389cf9703996" />

# Delete Modal Confirmation
<img width="1920" height="1200" alt="{7B6DE1FF-475B-482E-96F0-D37A348E71E1}" src="https://github.com/user-attachments/assets/7e1b02ba-6d88-4d8d-acca-a439a208a3e1" />

# Logout Modal Confirmation
<img width="1920" height="1200" alt="{5EB7B697-4A4C-48EC-AF75-3B80373D2869}" src="https://github.com/user-attachments/assets/e372bd0d-5a99-41e2-b8d8-f76098dd163f" />

# Log
## Login
[AuthBloc] ✓ Status: Authenticated
[API] Response Login: {"message":"Login Berhasil","token":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjQzZDY1OGU3LTI5N2MtNDRjNy1hMTU2LTM2YTU4NDgyNzkxMSIsInVzZXJuYW1lIjoicGFubiIsImlhdCI6MTc3NzY1MTYxMiwiZXhwIjoxNzc3NzM4MDEyfQ.b4PdWZlfV3CqDtAt5d2MiWV_ZQF5VqQZlyYvdqk5NE8","user":{"id":"43d658e7-297c-44c7-a156-36a584827911","username":"pann"}}

## Get All Hewan
[HewanBloc] ✓ FetchHewan: 5 data dimuat
[API] Response Get All Hewan: {"success":true,"message":"Data berhasil diambil!","data":[{"id":12,"nama":"My Kambing Guweh","jenis":"Kambing","tanggal_lahir":"2026-04-03","harga":909090,"status":"tersedia","createdAt":"2026-05-01T15:44:45.000Z","updatedAt":"2026-05-01T15:44:45.000Z"},{"id":11,"nama":"My Sapi Guweh Part 2","jenis":"Sapi","tanggal_lahir":"2026-04-01","harga":200000,"status":"terjual","createdAt":"2026-05-01T15:36:46.000Z","updatedAt":"2026-05-01T15:36:46.000Z"},{"id":10,"nama":"My Sapi Guweh","jenis":"Sapi","tanggal_lahir":"2026-05-01","harga":500000,"status":"tersedia","createdAt":"2026-05-01T15:16:09.000Z","updatedAt":"2026-05-01T15:24:53.000Z"},{"id":9,"nama":"sampi jerman","jenis":"sapi","tanggal_lahir":"2023-05-20","harga":4500000,"status":"tersedia","createdAt":"2026-05-01T15:00:56.000Z","updatedAt":"2026-05-01T15:03:10.000Z"},{"id":8,"nama":"Kambing Anubis","jenis":"Kambing","tanggal_lahir":"2023-05-20","harga":45000000,"status":"tersedia","createdAt":"2026-05-01T14:22:34.000Z","updatedAt":"2026-05-01T14:22:34.000Z"}]}
[HewanBloc] Change: HewanLoading() -> HewanLoaded([HewanModel(12, My Kambing Guweh, Kambing, 2026-04-03, 909090, tersedia), HewanModel(11, My Sapi Guweh Part 2, Sapi, 2026-04-01, 200000, terjual), HewanModel(10, My Sapi Guweh, Sapi, 2026-05-01, 500000, tersedia), HewanModel(9, sampi jerman, sapi, 2023-05-20, 4500000, tersedia), HewanModel(8, Kambing Anubis, Kambing, 2023-05-20, 45000000, tersedia)])

## Post Hewan
[HewanBloc] Event: CreateHewan({nama: Abu, jenis: Kucing, tanggal_lahir: 2026-05-01, harga: 5000000, status: tersedia})
[HewanBloc] Change: HewanInitial() -> HewanLoading()
[HewanBloc] Change: HewanLoading() -> HewanCreatedSuccess()
[HewanBloc] ✓ CreateHewan: Berhasil menambah data
[HewanBloc] Event: FetchHewan()
[HewanBloc] Change: HewanCreatedSuccess() -> HewanLoading()
[HewanBloc] Event: FetchHewan()
[API] Response Create Hewan: {"success":true,"message":"Data berhasil ditambahkan!","data":{"id":13,"nama":"Abu","jenis":"Kucing","tanggal_lahir":"2026-05-01","harga":5000000,"status":"tersedia","updatedAt":"2026-05-01T16:11:19.835Z","createdAt":"2026-05-01T16:11:19.835Z"}}

## Put Hewan 
[HewanBloc] Event: UpdateHewan(13, {nama: Abu, jenis: Kucing, tanggal_lahir: 2026-05-01, harga: 5000000, status: terjual})
[HewanBloc] Change: HewanInitial() -> HewanLoading()
[HewanBloc] Change: HewanLoading() -> HewanCreatedSuccess()
[HewanBloc] ✓ UpdateHewan: id=13 berhasil diupdate
[HewanBloc] Event: FetchHewan()
[HewanBloc] Change: HewanCreatedSuccess() -> HewanLoading()
[HewanBloc] Event: FetchHewan()
[API] Response Update Hewan: {"success":true,"message":"Update berhasil","data":{"id":13,"nama":"Abu","jenis":"Kucing","tanggal_lahir":"2026-05-01","harga":5000000,"status":"terjual","createdAt":"2026-05-01T16:11:19.000Z","updatedAt":"2026-05-01T16:16:37.781Z"}}

## Delete Hewan
[API] Response Delete Hewan: {"success":true,"message":"Data hewan berhasil dihapus"}

## Get Hewan By ID
[HewanBloc] ✓ FetchHewanById: id=13 dimuat
[API] Response Get Hewan By Id: {"success":true,"message":"Data berhasil diambil!","data":{"id":13,"nama":"Abu","jenis":"Kucing","tanggal_lahir":"2026-05-01","harga":5000000,"status":"terjual","createdAt":"2026-05-01T16:11:19.000Z","updatedAt":"2026-05-01T16:16:37.000Z"}}

## Logout
[AuthBloc] ✓ Logged Out
[AuthBloc] Change: Authenticated(eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjQzZDY1OGU3LTI5N2MtNDRjNy1hMTU2LTM2YTU4NDgyNzkxMSIsInVzZXJuYW1lIjoicGFubiIsImlhdCI6MTc3NzY1MTYxMiwiZXhwIjoxNzc3NzM4MDEyfQ.b4PdWZlfV3CqDtAt5d2MiWV_ZQF5VqQZlyYvdqk5NE8) -> Unauthenticated()













