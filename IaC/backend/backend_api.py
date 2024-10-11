from fastapi import FastAPI, HTTPException, Request
from fastapi.responses import JSONResponse
import joblib
import os
from contrato import EspecificacoesCasa
from pydantic import BaseModel
from database import salvar_no_postgres

app = FastAPI()

# Load the trained machine learning model
modelo = joblib.load(os.path.join(os.getcwd(), 'models', 'model_pipeline.pkl'))

class PrevisaoRequest(BaseModel):
    especificacoes_imovel: EspecificacoesCasa
    host_name: str

@app.post("/prever/")
async def prever_preco(previsao_request: PrevisaoRequest, request: Request):

    especificacoes_imovel = previsao_request.especificacoes_imovel
    host_name = previsao_request.host_name
    dados_entrada = [[
                        especificacoes_imovel.host_is_superhost,
                        especificacoes_imovel.host_listings_count,
                        especificacoes_imovel.latitude, 
                        especificacoes_imovel.longitude,
                        especificacoes_imovel.accommodates,
                        especificacoes_imovel.bathrooms,
                        especificacoes_imovel.bedrooms,
                        especificacoes_imovel.beds,
                        especificacoes_imovel.extra_people,
                        especificacoes_imovel.minimum_nights,
                        especificacoes_imovel.instant_bookable,
                        especificacoes_imovel.ano,
                        especificacoes_imovel.mes,
                        especificacoes_imovel.n_amenities,
                        especificacoes_imovel.property_type_Apartment,
                        especificacoes_imovel.property_type_Bed_and_breakfast,
                        especificacoes_imovel.property_type_Condominium,
                        especificacoes_imovel.property_type_Guest_suite,
                        especificacoes_imovel.property_type_Guesthouse,
                        especificacoes_imovel.property_type_Hostel,
                        especificacoes_imovel.property_type_House,
                        especificacoes_imovel.property_type_Loft,
                        especificacoes_imovel.property_type_Outros,
                        especificacoes_imovel.property_type_Serviced_apartment,
                        especificacoes_imovel.room_type_Entire_home_apt,
                        especificacoes_imovel.room_type_Hotel_room,
                        especificacoes_imovel.room_type_Private_room,
                        especificacoes_imovel.room_type_Shared_room,
                        especificacoes_imovel.cancellation_policy_flexible,
                        especificacoes_imovel.cancellation_policy_moderate,
                        especificacoes_imovel.cancellation_policy_strict,
                        especificacoes_imovel.cancellation_policy_strict_14_with_grace_period,
                    ]]
    try:
        preco_estimado = modelo.predict(dados_entrada)[0]

        response_data = {"preco_estimado": preco_estimado, "dados": especificacoes_imovel.dict()}

        # Save result to PostgreSQL database
        salvar_no_postgres(dados_entrada, host_name, preco_estimado)
        
        return JSONResponse(content=response_data)

    except ValueError as e:
        raise HTTPException(status_code=400, detail=f"Error in input data: {e}")

    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Server error: {e}")
