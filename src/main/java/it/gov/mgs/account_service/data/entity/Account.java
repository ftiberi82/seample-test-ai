package it.gov.mgs.account_service.data.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.OffsetDateTime;
import java.util.UUID;

/**
 * Account applicativo (tabella ACCOUNT) identificato da uno username e dallo stato di attivazione.
 * I campi di auditing/validità sono ereditati da {@link AuditedEntity}.
 */
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "ACCOUNT")
public class Account extends AuditedEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(name = "id", nullable = false, columnDefinition = "uniqueidentifier")
    private UUID id;

    @Column(name = "username", nullable = false, length = 255, unique = true)
    private String username;

    @Column(name = "active", nullable = false)
    private Boolean active;

}
